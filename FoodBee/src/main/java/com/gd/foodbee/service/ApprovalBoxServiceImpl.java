package com.gd.foodbee.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gd.foodbee.dto.ApprovalBoxDTO;
import com.gd.foodbee.dto.ApprovalBoxStateDTO;
import com.gd.foodbee.mapper.ApprovalBoxMapper;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ApprovalBoxServiceImpl implements ApprovalBoxService {
	//결재함 전체 리스트
	@Autowired 
	private ApprovalBoxMapper approvalBoxMapper;
	private static final int ROW_PER_PAGE = 10;
	
	//내 결재함 전체리스트
	@Override
	public List<ApprovalBoxDTO> getApprovalListAll(int currentPage, int empNo){
		
		int beginRow = 0;
        beginRow = (currentPage -1) * ROW_PER_PAGE;
        
        return approvalBoxMapper.getApprovalListAll(empNo, beginRow, ROW_PER_PAGE);
	}
	
	//결재함 미결리스트
	@Override
	public List<ApprovalBoxDTO> getZeroListAll(int currentPage, int empNo){
		int beginRow = 0;
        beginRow = (currentPage -1) * ROW_PER_PAGE;
        
        return approvalBoxMapper.getZeroListAll(empNo, beginRow, ROW_PER_PAGE);
	}
	
	//결재함 기결리스트
	@Override
	public List<ApprovalBoxDTO> getOneListAll(int currentPage, int empNo){
		int beginRow = 0;
        beginRow = (currentPage -1) * ROW_PER_PAGE;
        
        return approvalBoxMapper.getOneListAll(empNo, beginRow, ROW_PER_PAGE);
	}
	
	//미결 총 갯수
	public int countZeroState(int empNo) {
		return approvalBoxMapper.countZeroTypeList(empNo);
	}
	//기결 총 갯수
	public int countOneState(int empNo) {
		return approvalBoxMapper.countOneTypeList(empNo);
	}
	
	//결재함 전체 Lastpage
	@Override
	public int getAllLastPage(int empNo) {
		int count = approvalBoxMapper.countAllList(empNo);
		int lastPage = (int) Math.ceil((double) count / ROW_PER_PAGE);
		
		return lastPage;
	}
	
	//미결 LastPage
	@Override
	public int getZeroLastPage(int empNo) {
		int count = approvalBoxMapper.countZeroTypeList(empNo);
		int lastPage = (int) Math.ceil((double) count / ROW_PER_PAGE);
		
		return lastPage;
	}
	
	//기결 LastPage
	@Override
	public int getOneLastPage(int empNo) {
		int count = approvalBoxMapper.countOneTypeList(empNo);
		int lastPage = (int) Math.ceil((double) count / ROW_PER_PAGE);
		
		return lastPage;
	}
	
	// 결재상태 건수(결재대기, 승인중, 승인완료, 반려) 
	@Override
	public ApprovalBoxStateDTO getStateBox(int empNo) {
		return approvalBoxMapper.getStateBox(empNo);
	}
}