package com.gd.foodbee.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gd.foodbee.dto.GroupDTO;
import com.gd.foodbee.mapper.GroupMapper;

@Service
public class GroupServiceImpl implements GroupService{

	@Autowired
	private GroupMapper groupMapper;
	
	// 전체 본사/지사 리스트
	// 파라미터 : X
	// 반환 값 : List<GroupDTO>
	// 사용 클래스 : GroupController.getOfficeList
	@Override
	public List<GroupDTO> getOfficeList() {
		
		return groupMapper.selectOfficeList();
	}

	// 본사/지사에 포함된 부서 리스트
	// 파라미터 : String dptNo
	// 반환 값 : List<GroupDTO>
	// 사용 클래스 : GroupController.getDeptListByOffice
	@Override
	public List<GroupDTO> getDeptListByOffice(String dptNo) {
		
		return groupMapper.selectDeptListByOffice(dptNo);
	}

	// 부서에 포함된 팀 리스트
	// 파라미터 : String dptNo
	// 반환 값 : List<GroupDTO>
	// 사용 클래스 : GroupController.getTeamListByDept
	@Override
	public List<GroupDTO> getTeamListByDept(String dptNo) {
		
		return groupMapper.selectTeamListByDept(dptNo);
	}

	// 전체 부서 리스트
	// 파라미터 : X
	// 반환 값 : List<GroupDTO>
	// 사용 클래스 : GroupController.getDeptList
	@Override
	public List<GroupDTO> getDeptList() {
		
		return groupMapper.selectDeptList();
	}

	// 전체 팀 리스트
	// 파라미터 : X
	// 반환 값 : List<GroupDTO>
	// 사용 클래스 : GroupController.getTeamList
	@Override
	public List<GroupDTO> getTeamList() {
		
		return groupMapper.selectTeamList();
	}
	

	
	
}