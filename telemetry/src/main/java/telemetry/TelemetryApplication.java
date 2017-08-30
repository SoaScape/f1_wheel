package telemetry;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import lombok.extern.log4j.Log4j;

@SpringBootApplication
@Log4j
public class TelemetryApplication {
	public static void main(String[] args) {
		final SpringApplication application = new SpringApplication(TelemetryApplication.class);
		try {
            application.setWebEnvironment(false);
            application.run(args);
        } catch (final Exception e) {
            log.error(e);
            System.exit(1);
        }
	}
}
