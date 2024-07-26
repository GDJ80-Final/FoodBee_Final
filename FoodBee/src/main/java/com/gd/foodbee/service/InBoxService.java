package com.gd.foodbee.service;

import java.util.List;

import com.gd.foodbee.dto.InBoxDTO;
import com.gd.foodbee.dto.InBoxStateDTO;
import com.gd.foodbee.mapper.InBoxMapper;

public interface InBoxService {
	// 전체 수신 리스트
	// 파라미터 : currentPage, empNo
	// 반환값 : List<InBoxMapper>
	// 사용클래스 : inBoxController.inBox 
	List<InBoxDTO> getReferrerList(int currentPage, int empNo);
	
	// 수신 참조된 리스트 총갯수
	// 파라미터 : int empNo
	// 반환값 : int
	// 사용클래스 : X
	int countAllReferrerList(int empNo);
	
	// 수신 참조된 리스트 LastPage
	// 파라미터 : int empNo
	// 반환값 : int
	// 사용클래스 : inBoxController.inBox
	int allReferrerLastPage(int empNo);
	
	// 결재상태(결재대기, 승인중, 승인완료, 반려) 총갯수
	// 파라미터 : int empNo
	// 반환값 : InBoxStateDTO
	// 사용클래스 : InBoxController.inBox
	InBoxStateDTO getStateBox(int empNo);
}