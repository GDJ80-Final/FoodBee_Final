package com.gd.foodbee.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ProfileDTO {
	private int empNo;
	private String originalFile;
	private String saveFile;
	private String type;
	private String createDatetime;
	private String updateDatetime;
}
