package com.gd.foodbee.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RevenueDTO {
	private String referenceMonth; 
	private String categoryName;
	private int drafterEmpNo;
	private int revenue;
}