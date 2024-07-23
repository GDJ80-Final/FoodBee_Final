package com.gd.foodbee.service;

import java.io.File;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.gd.foodbee.mapper.ApprovalSignMapper;
import com.gd.foodbee.util.FileFormatter;
import com.gd.foodbee.util.TeamColor;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ApprovalSignServiceImpl implements ApprovalSignService{

	@Autowired
	private ApprovalSignMapper approvalSignMapper;

	@Override
	public void saveApprovalSign(int empNo, 
				String url, 
				HttpServletRequest request) {
		
		int row = 0;
		if(approvalSignMapper.selectApprovalSign(empNo) == null) {
			row = approvalSignMapper.insertApprovalSign(empNo, url);
		} else {
			row = approvalSignMapper.updateApprovalSign(empNo, url);
		}
		
		if(row != 1){
			throw new RuntimeException();
		}
		
	}
}