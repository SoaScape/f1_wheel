package telemetry.domain;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class CodemastersLookups {
	@Value("#{${fuel-mix-lookup}}")
	public Map<Integer, String> fuelMixLookup;	
	@Value("#{${team-lookup}}")
	public Map<Integer, String> teamLookup;	
	@Value("#{${track-lookup}}")
	public Map<Integer, String> trackLookup;
}
