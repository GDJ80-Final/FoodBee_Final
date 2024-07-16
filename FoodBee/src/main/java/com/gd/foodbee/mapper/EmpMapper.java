package com.gd.foodbee.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.gd.foodbee.dto.EmpDTO;
import com.gd.foodbee.dto.LoginDTO;
import com.gd.foodbee.dto.SignupDTO;

@Mapper
public interface EmpMapper {
	
	// 로그인
	// 파라미터 : LoginDTO
	// 반환 값 : EmptDTO
	// 사용 클래스 : LoginServiceimpl.login
	EmpDTO selectEmpByNoAndPw(LoginDTO loginDTO);
	
	// 이메일 발송
	// 파라미터 : int empNo, String empEmail
	// 반환 값 : EmptDTO
	// 사용 클래스 : EmailServiceimpl.sendEmail
	EmpDTO selectEmpByNoAndEmail(int empNo, String empEmail);
	
	// 임시비밀번호로 변경
	// 파라미터 : int empNo, String empPw
	// 반환 값 : int
	// 사용 클래스 : LoginServiceImpl.modifyEmpPw
	int updateEmpPw(int empNo, String empPw);
	
	//회원가입
	//파라미터 : EmpDTO empDTO
	//반환 값 : int
	//사용 클래스 : EmpServiceImpl.updateEmpSignup
	int updateEmpSignup(EmpDTO empDTO);
}