package telemetry.domain;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class CodemastersLookups {
	@Value("#{${f1-2017-data-mappings}}")
	private Map<String, Integer> f12017DataMappings;
	@Value("#{${f1-2017-car-data-mappings}}")
	private Map<String, Integer> f12017CarDataMappings;
	@Value("#{${fuel-mix-lookup}}")
	private Map<Integer, String> fuelMixLookup;	
	@Value("#{${team-lookup}}")
	private Map<Integer, String> teamLookup;	
	@Value("#{${track-lookup}}")
	private Map<Integer, String> trackLookup;
	@Value("#{${tyre-compound-lookup}}")
	private Map<Integer, String> tyreCompoundLookup;
}
