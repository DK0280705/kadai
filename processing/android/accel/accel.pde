import ketai.sensors.*;
import java.util.ArrayList;

KetaiSensor sensor;

float accelX, accelY, accelZ;
float ballX, ballY;
float velocityX, velocityY;
float ballRadius = 50;
float bounceFactor = 0.7;

int lastUpdateTime;
ArrayList<Runner> runners;
int runnerCount = 3;
float runnerRadius = 20;
float runnerFleeSpeed = 300;
float runnerTargetDistance = 1000;
float runnerCenterReturnRadius = 500;
float runnerWanderSpeedMin = 200;
float runnerWanderSpeedMax = 800;
float runnerWanderDurationMin = 1.0;
float runnerWanderDurationMax = 2.0;
float runnerWanderCooldownMin = 1.0;
float runnerWanderCooldownMax = 2.5;
float tiltFactor = 2000; // px/ms^2 applied when fully tilted (about 1 g when meterToPixel=100)
float terminalVelocity = 2000; // px/s cap to keep motion bounded
int killCount;

void setup() {
    orientation(PORTRAIT);
    sensor = new KetaiSensor(this);
    sensor.start();
    frameRate(60);

    ballX = width / 2;
    ballY = height / 2;
    runners = new ArrayList<Runner>();
    for (int i = 0; i < runnerCount; i++) {
        runners.add(new Runner());
    }
    lastUpdateTime = millis();
}

void draw() {
    background(255);
    // We use game loop style updates here
    float deltaTime = computeDeltaTime();
    updatePhysics(deltaTime);
    updateRunners(deltaTime);
    updateKillEffect(deltaTime);

    // Draw a circle that moves based on accelerometer data
    fill(100, 150, 250);
    ellipse(ballX, ballY, ballRadius * 2, ballRadius * 2);

    // Display accelerometer values
    fill(0);
    textSize(16);
    text("Accel X: " + nf(accelX, 1, 2) + " m/s^2", 10, height - 60);
    text("Accel Y: " + nf(accelY, 1, 2) + " m/s^2", 10, height - 40);
    text("Accel Z: " + nf(accelZ, 1, 2) + " m/s^2", 10, height - 20);
    text("Kills: " + killCount, 10, 40);
}

void onAccelerometerEvent(float x, float y, float z) {
    accelX = x;
    accelY = y;
    accelZ = z;
}

float computeDeltaTime() {
    int currentTime = millis();
    float deltaTime = (currentTime - lastUpdateTime) / 1000.0;
    lastUpdateTime = currentTime;
    return constrain(deltaTime, 0.0, 0.1);
}

void updatePhysics(float deltaTime) {
    float magnitude = sqrt(accelX * accelX + accelY * accelY);
    if (magnitude < 0.0001) {
        return;
    }
    float ax = (-accelX / magnitude) * tiltFactor;
    float ay = (accelY / magnitude) * tiltFactor;

    velocityX += ax * deltaTime;
    velocityY += ay * deltaTime;
    
    //Use Pythagorean magnitude to limit speed
    float speed = sqrt(velocityX * velocityX + velocityY * velocityY);
    if (speed > terminalVelocity) {
        float scale = terminalVelocity / speed;
        velocityX *= scale;
        velocityY *= scale;
    }

    ballX += velocityX * deltaTime;
    ballY += velocityY * deltaTime;

    handleBounds();
}

void updateRunners(float deltaTime) {
    if (runners == null) {
        return;
    }

    for (Runner runner : runners) {
        runner.update(deltaTime);
    }
}

void updateKillEffect(float deltaTime) {
    for (Runner runner : runners) {
        runner.updateKillEffect(deltaTime);
    } 
}

void handleBounds() {
    float minX = ballRadius;
    float maxX = width - ballRadius;
    float minY = ballRadius;
    float maxY = height - ballRadius;

    if (ballX < minX) {
        ballX = minX;
        velocityX *= -bounceFactor;
    } else if (ballX > maxX) {
        ballX = maxX;
        velocityX *= -bounceFactor;
    }

    if (ballY < minY) {
        ballY = minY;
        velocityY *= -bounceFactor;
    } else if (ballY > maxY) {
        ballY = maxY;
        velocityY *= -bounceFactor;
    }
}

class Runner {
    float x;
    float y;
    float killEffectX;
    float killEffectY;
    float killEffectTime = 0;
    final float killEffectDuration = 0.5; // seconds
    float wanderSpeed;
    float wanderAngle;
    float wanderTimeLeft;
    float wanderCooldown;

    Runner() {
        respawn();
    }

    void respawn() {
        if (width == 0 || height == 0) {
            x = 0;
            y = 0;
            return;
        }

        x = width * random(0.25, 0.75);
        y = height * random(0.25, 0.75);
        wanderTimeLeft = 0;
        wanderCooldown = random(0.8, 2.0);
        wanderSpeed = random(runnerWanderSpeedMin, runnerWanderSpeedMax);
    }

    void kill() {
        killCount++;
        killEffectX = x;
        killEffectY = y;
        killEffectTime = killEffectDuration; 
    }

    void updateKillEffect(float deltaTime) {
        if (killEffectTime > 0) {
            killEffectTime = max(0, killEffectTime - deltaTime);
            float progress = 1 - (killEffectTime / killEffectDuration);
            float radius = lerp(ballRadius * 0.5, ballRadius * 2.2, progress);
            int alpha = int(lerp(255, 0, progress));

            noFill();
            stroke(255, 100, 50, alpha);
            strokeWeight(4);
            ellipse(killEffectX, killEffectY, radius * 2, radius * 2);
            strokeWeight(1);
            noStroke();
        }
    }

    void update(float deltaTime) {
        if (width == 0 || height == 0 || deltaTime <= 0) {
            return;
        }
        
        // To make not too far from center
        float centerDX = x - width / 2;
        float centerDY = y - height / 2;
        float centerDistance = dist(x, y, width / 2, height / 2);

        if (centerDistance > runnerCenterReturnRadius) {
            float nx = centerDX / centerDistance;
            float ny = centerDY / centerDistance;
            x -= nx * runnerFleeSpeed * deltaTime;
            y -= ny * runnerFleeSpeed * deltaTime;
        }

        float dx = x - ballX;
        float dy = y - ballY;
        float distance = dist(ballX, ballY, x, y);

        if (distance < runnerTargetDistance) {
            if (distance < (ballRadius + runnerRadius)) {
                kill();
                respawn();            
                return;
            }

            if (distance == 0) {
                dx = runnerRadius;
                dy = 0;
                distance = runnerRadius;
            }

            float nx = dx / distance;
            float ny = dy / distance;
            x += nx * runnerFleeSpeed * deltaTime;
            y += ny * runnerFleeSpeed * deltaTime;

            wanderTimeLeft = 0;
            wanderCooldown = random(0.8, 1.6);
        } else {
            if (wanderTimeLeft > 0) {
                x += cos(wanderAngle) * wanderSpeed * deltaTime;
                y += sin(wanderAngle) * wanderSpeed * deltaTime;
                wanderTimeLeft -= deltaTime;
            } else {
                wanderCooldown -= deltaTime;
                if (wanderCooldown <= 0) {
                    wanderAngle = random(TWO_PI);
                    wanderSpeed = random(runnerWanderSpeedMin, runnerWanderSpeedMax);
                    wanderTimeLeft = random(runnerWanderDurationMin, runnerWanderDurationMax);
                    wanderCooldown = random(runnerWanderCooldownMin, runnerWanderCooldownMax);
                }
            }
        }

        x = constrain(x, runnerRadius, width - runnerRadius);
        y = constrain(y, runnerRadius, height - runnerRadius);
        

        fill(250, 150, 100);
        ellipse(x, y, runnerRadius * 2, runnerRadius * 2);
    }
}