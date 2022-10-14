package com.dozip.controller;

import com.dozip.service.PartnersService;
import com.dozip.vo.PartnersVO;
import com.dozip.vo.Partners_subVO;
import com.dozip.vo.PortfolioVO;
import com.dozip.vo.QnaVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@Controller
@RequestMapping("partners/*") //컨트롤러 자체 URL 매핑주소 등록
public class PartnersController {

    @Autowired
    private PartnersService partnersService;


    @RequestMapping(value = "/main") //파트너스 메인
    public String partners() {
        return "/partners/index";
    }


    /*회원가입, 로그인, 아이디 비번 찾기 관련 메서드
     *
     * */

    //회원가입 페이지
    @GetMapping("/signup")
    public String partners_signup(Model model) {
        String[] email = {"직접입력", "gmail.com", "naver.com", "hanmail.net", "nate.com"};
        model.addAttribute("email", email);
        return "/partners/join/signup";
    }// partners_signup()

    //회원 가입시 아이디 체크
    @PostMapping("/partners_idCheck")
    public void id_check(String pId, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        PartnersVO vo = partnersService.getPartnersInfo(pId);

        int re = -1;
        if (vo != null) re = 1;
        out.print(re);
    }//id_check()

    //회원가입
    @PostMapping("partners_join_ok")
    public String partners_join_ok(PartnersVO pv,HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out =response.getWriter();

        int result=partnersService.checkBusinessNum(pv);
        System.out.println(result);
        if(result==1){
            out.println("<script>");
            out.println("alert('이미 가입된 사업자번호가 있습니다')");
            out.println("history.go(-1);");
            out.println("</script>");
        }
        else{
            partnersService.insertPartners(pv);
            out.println("<script>");
            out.println("alert('회원가입에 성공하였습니다.')");
            out.println("location='/partners/main';");
            out.println("</script>");
        }
        return null;
    }//partners_join_ok

    //파트너스 아이디찾기
    @PostMapping("/partners_findid")
    public String partners_findid(String findid_business_num, String findid_pTel, String findid_email,
                                  HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        //넘어온정보 알맞게 가공한후 (전화번호)
        findid_pTel = findid_pTel.replaceAll("-", "");

        //사업자 번호를 기준으로 db를 통해 정보 조회한후
        PartnersVO fv = partnersService.getPartnersInfo2(findid_business_num);

        //넘어온 정보와 db 값 비교
        try {
            //이메일 정보를 가공한후
            String dbEmail = fv.getPMailId() + "@" + fv.getPMailDomain();
            String db_business_num = fv.getBusinessNum();
            String db_pTel = fv.getPTel();

            String email_id = fv.getPMailId();
            String email_domain = fv.getPMailDomain();
            String db_email = email_id + "@" + email_domain;

            if (db_business_num.equals(findid_business_num) && db_pTel.equals(findid_pTel) && db_email.equals(findid_email)) {
                out.println("<script>");
                out.println("alert('당신의 아이디는 " + fv.getPId() + " 입니다.')");
                out.println("location='/partners/main'");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('일치하는 정보가 없습니다!')");
                out.println("location='/partners/main'");
                out.println("</script>");
            }
        } catch (Exception e) {
            out.println("<script>");
            out.println("alert('일치하는 정보가 없습니다!')");
            out.println("location='/partners/main'");
            out.println("</script>");
        }
        return null;
    }//partners_findid()

    //로그인 인증
    @RequestMapping(value = "/login_ok")
    public ModelAndView partners_login_ok(PartnersVO vo, HttpServletResponse response, HttpSession session) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        PartnersVO pInfo = partnersService.getPartnersInfo(vo.getPId()); //파트너스 아이디를 기준으로 파트너스 정보를 가져옴


        if (pInfo == null) {
            out.println("<script>");
            out.println("alert('존재하지 않는 아이디입니다')");
            out.println("history.back()");
            out.println("</script>");
        } else {
            if (!pInfo.getPPw().equals(vo.getPPw())) {
                out.println("<script>");
                out.println("alert('비밀번호가 일치하지 않습니다')");
                out.println("history.back()");
                out.println("</script>");
            } else {
                session.setAttribute("id", pInfo.getPId());
                session.setAttribute("businessName", pInfo.getBusinessName());
                session.setAttribute("businessNum", pInfo.getBusinessNum());
                session.setMaxInactiveInterval(-1);   //세션을 통해 로그인 시간 설정
                return new ModelAndView("redirect:/partners/main");
            }
        }
        return null;
    }//partners_login_ok

    //파트너스 정보 찾기 페이지
    @GetMapping("partners_findinfo")
    public String partners_findinfo(){
        return "/partners/join/find_info";
    }//partners_findinfo()

    //로그아웃
    @RequestMapping("/logout")
    public ModelAndView partners_logout(HttpSession session) {
        session.invalidate();
        return new ModelAndView("redirect:/partners/main");
    }//partners_logout



    /*    요금제
     *
     *   */

    //요금제
    @GetMapping("/planning")
    public String setPlan() {
        return "/partners/interior_Plan/plan";

    }//setPlan()
    //월정액 요금제
    @GetMapping("/plan_monthly")
    public String plan_monthly(){
        return "/partners/interior_Plan/monthly";
    }//plan_monthly()

    //부분 시공 요금제
    @GetMapping("/plan_part")
    public String plan_part(){
        return "/partners/interior_Plan/part";
    }//plan_part()



    /*견적 의뢰
     *
     */
    @RequestMapping(value = "/bid") //입찰의뢰
    public String bid() {
        return "/partners/estimate_request/bid";
    }

    @RequestMapping(value = "/bid_detail") //입찰 상세목록
    public String bid_detail() {
        return "/partners/estimate_request/bid_detail";
    }

    @RequestMapping(value = "/my_bid") //내 입찰
    public String my_bid() {
        return "/partners/estimate_request/my_bid";
    }

    @RequestMapping(value = "/construct_request") //시공요청
    public String construct_request() {
        return "/partners/estimate_request/construct_request";
    }

    @RequestMapping(value = "/request_detail") //시공요청 상세목록
    public String construct_request_detail() {
        return "/partners/estimate_request/construct_request_detail";
    }

    /*견적 관리
     *
     *
     *  */
    @RequestMapping(value = "/estimate_list")
    public String estimate_list() {  // 견적목록 
        return "/partners/estimate/estimate_list";
    }



    /*내 공사
     *
     *
     * */


    @RequestMapping(value = "/interior_list")
    public String interior_list() {
        return "/partners/myinterior/interior_List";
    }

    @RequestMapping(value = "/schedule_list")
    public String schedule_list() {
        return "/partners/myinterior/schedule_List";
    }

    @RequestMapping(value = "/balance_details")
    public String balance_details() {
        return "/partners/myinterior/balance_details";
    }


    /* 시공사례 관리
     *
     */
    // 포트폴리오 페이지
    @RequestMapping(value = "/upload")
    public String portfolioUpload() {
        return "/partners/portfolio/p_upload";
    }
    // 포트폴리오 등록
    @RequestMapping(value = "/upload_photo")
    public String portfolioUpload_photo(PortfolioVO pv, HttpSession session, HttpServletResponse response,
                                        HttpServletRequest request) {
        pv.setBusinessNum((String) session.getAttribute("businessNum"));
        if (pv.getPf_addr2().isEmpty())  //마이바티스에 널 값 insert시 오류나서 문자열 처리
            pv.setPf_addr2(" ");

        if(pv.getPf_subtype().contains(",")){

        String[] str =pv.getPf_subtype().split(",");
        if(pv.getPf_type().equals("주거공간")){
            pv.setPf_subtype(str[0]);
            System.out.println("주거공간 //" +str[0] );
        }else if(pv.getPf_type().equals("상업공간")){
            pv.setPf_subtype(str[1]);
            System.out.println("상업공간 //" +str[1] );
        }
        }
        Cookie cookie = new Cookie("pf_no", String.valueOf(partnersService.addPortfolio(pv)));
        response.addCookie(cookie);
        return "/partners/portfolio/p_upload_photo";
    }

    //포트폴리오 사진등록
    @RequestMapping(value = "/upload_photo_ok")
    public String upload_photo_ok(PortfolioVO pv, @RequestParam List<MultipartFile> photos,
                                  HttpServletResponse response, HttpServletRequest request) throws IOException {
        response.setContentType("text/html;charset=UTF-8");

        int pf_no = 0;
        Cookie[] cookies = request.getCookies();
        for (Cookie c : cookies) {
            if (c.getName().equals("pf_no")) {
                pf_no = Integer.parseInt(c.getValue()); //쿠키에서 포트폴리오 번호 가져옴 -> 사진 삽입 위해
            }
        }




    /* 중요!!! 이미지 파일 업로드하고 html 로 불러오기 위한 작업
        1. 아래 uploadPath 주소를 자신의 프로젝트 주소의 upload 폴더로 바꿉니다.

            String uploadPath = "upload폴더 경로 주소" + pf_no;
        2. 사진 등록후 서버 한번 재시작 해야 포트폴리오가 불러와집니다
        3. 작업 하신후에 upload 폴더안에 있는 내용들은 깃에 올리지 말아주세요~~ (**삭제 혹은 무시**)
        */

       String uploadPath = "D:\\DoZip\\src\\main\\resources\\static\\upload\\" + pf_no+"\\";
       String uploadDBPath ="/upload/"+ pf_no+"/";
        File dir = new File(uploadPath);

        if (!dir.isDirectory()) { //폴더가 없다면 생성
            dir.mkdirs();
        }
        int i = 1;
        System.out.println("등록된 사진 수: "+ photos.size());
        
        
        String dbFilename[]=new String[5];
        String saveFilename[]=new String[5];

        for(int j=1; j<=photos.size();j++) {
            dbFilename[j-1]=uploadDBPath+ "photo0" + j + ".jpg";   //String 객체에 DB(html에서 불러올) 파일명 저장
            saveFilename[j-1]=uploadPath+ "photo0" + j + ".jpg";   //String 객체에 실제 파일명 저장
            photos.get(j-1).transferTo(new File(saveFilename[j-1])); //실제 파일저장.
            System.out.println(dbFilename[j-1]);

        }
        pv.setPf_photo1(dbFilename[0]);
        pv.setPf_photo2(dbFilename[1]);
        pv.setPf_photo3(dbFilename[2]);
        pv.setPf_photo4(dbFilename[3]);
        pv.setPf_photo5(dbFilename[4]);





        /*for (MultipartFile photo : photos) {

            System.out.println(photo.getOriginalFilename());
            photo.transferTo(new File(uploadPath+ "/photo0" + i + ".jpg"));
            if(i==1){
                pv.setPf_photo1(uploadPath+ "/photo0" + i + ".jpg");
            }
            if(i==2){
                pv.setPf_photo2(uploadPath+ "/photo0" + i + ".jpg");
            }
            if(i==3){
                pv.setPf_photo3(uploadPath+ "/photo0" + i + ".jpg");
            }
            if(i==4){
                pv.setPf_photo4(uploadPath+ "/photo0" + i + ".jpg");
            }
            if(i==5){
                pv.setPf_photo5(uploadPath+ "/photo0" + i + ".jpg");
            }
            i++;
        } */

        pv.setPf_no(pf_no);
        partnersService.insertPort_Photos(pv);
        return "redirect:/partners/main";
    }//upload_photo_ok


    @RequestMapping(value = "/portfolio_list")  //견적목록
    public String portfolio_list() {
        return "/portfolio/p_list";
    }


    /*광고 관리
     *
     * */
    @RequestMapping(value = "/marketing")
    public String marketing() {  // 고객문의 글 보기
        return "/partners/marketing/marketing";
    }


    /*고객 관리
     *
     * */


    // 검색 전,후 고객문의 글 보기
    @RequestMapping(value = "/customer_qna")
    public String customerQna(Model model, HttpSession session, HttpServletRequest request, QnaVO findQ) throws Exception {
        request.setCharacterEncoding("UTF-8");
        // 로그인한 파트너스 사업자 번호(세션에 저장되 있음) 불러오기
        String businessNum = (String) session.getAttribute("businessNum");

        int page =1; //쪽번호
        int limit = 8; //한페이지에 보여질 개수

        String find_field = null;
        String find_text = null;
        String answer = null;

        if(request.getParameter("page")!= null)
            page=Integer.parseInt(request.getParameter("page"));
        if(request.getParameter("answer")!=null)
            answer=request.getParameter("answer");

        System.out.println("answer : " + request.getParameter("answer"));

        if(request.getParameter("find_text")!= null && request.getParameter("find_field") != null) {
            find_text = request.getParameter("find_text").trim();
            find_field = request.getParameter("find_field");
            if (find_field.equals("customer_name")) {
                findQ.setFind_text(find_text);
            } else if (find_field.equals("qna_type")) {
                findQ.setFind_text("%" + find_text + "%");
            }
        }
        findQ.setFind_field(find_field);
        findQ.setAnswer(answer);
        findQ.setBusinessNum(businessNum);

        int listcount = partnersService.getListCount(findQ); //검색전후 레코드 개수

        int startrow=(page-1)*8+1; //읽기 시작할 행번호
        int endrow = startrow+limit-1; //읽을 마지막 행번호
        findQ.setStartrow(startrow);     findQ.setEndrow(endrow);

        List<QnaVO> qlist = partnersService.getQnaList(findQ); // 검색 전후 목록

        int maxpage = (int)((double)listcount/limit+0.95); //총 페이지 수
        System.out.println("============================");
        int startpage = (((int)((double)page/10+0.9))-1)*10+1; //시작 페이지
        int endpage = maxpage; //마지막 페이지

        if(endpage>startpage+10-1) endpage=startpage+10-1;

        model.addAttribute("page", page);
        model.addAttribute("startpage", startpage);
        model.addAttribute("endpage", endpage);
        model.addAttribute("maxpage", maxpage);
        model.addAttribute("listcount", listcount); //레코드 개수
        model.addAttribute("answer", answer);
        model.addAttribute("find_text", find_text);
        model.addAttribute("find_field", find_field);
        model.addAttribute("qlist", qlist);

        return "/partners/customer/qna";
    }//customerQna()

    //고객문의글 답변
    @ResponseBody
    @PostMapping("/customer_reply_ok")
    public String customer_reply_ok(HttpSession session, QnaVO qv) {
        qv.setBusinessNum((String) session.getAttribute("businessNum")); //사업자번호
        qv.setQna_title(" "); //마이바티스 널값 insert 시 오류로 인해 추가

        int result=partnersService.insertQna(qv);
        System.out.println(result);

        return null;
    }//customer_reply_ok


    //고객문의글 삭제
    @ResponseBody
    @GetMapping("/customer_qna_del_ok")
    public String customer_qna_del_ok(QnaVO dv){
        int result=partnersService.deleteReply(dv);

        int r = partnersService.selqnaRef(dv);
        if(r==1){
            partnersService.returnState(dv);
        }
        System.out.println(result);

        return null;
        /*
        삭제시 아작스 실행 확인해야함



         */
    }//customer_qna_del_ok()

    @RequestMapping(value = "/review")
    public String customerReview() {  // 고객문의 글 보기
        return "/partners/customer/review";
    }


    /*My page
    *
    */
    @RequestMapping(value="/data_manage")
    public ModelAndView data_manage(HttpServletResponse response, HttpSession session) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out=response.getWriter();

        String businessNum=(String)session.getAttribute("businessNum");
//        if(businessNum==null) {
//            out.println("<script>");
//            out.println("alert('다시 로그인하세요!');");
//            out.println("location='/partners';");
//            out.println("</script>");
//        }else {
        //System.out.println(businessNum);
        PartnersVO p=this.partnersService.getMember(businessNum);//사업자번호에 해당하는 회원정보를 DB로부터 가져옴.
        //Partners_subVO ps=this.partnersService.getPartnersSub(businessNum);

           //System.out.println(p.toString());
           //System.out.println(p.getPName()+" "+p.getPTel());
           //System.out.println(ps.getBusinessNum()+" "+ps.getPShortstate()+" "+ps.getPHomepg());

            ModelAndView m=new ModelAndView();
            m.addObject("p", p);//p 키이름에 p객체 저장
            m.addObject("pName",p.getPName());
            m.addObject("pTel",p.getPTel());

            //m.addObject("ps", ps);

            m.setViewName("/partners/mypage/data_manage");
            return m;
//        }
    }//data_manage()

    @RequestMapping(value="/data_manage_ok")
    public String data_manage_edit_ok(HttpServletResponse response,HttpServletRequest request,
        HttpSession session) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String pAddress=request.getParameter("pAddress");
        String pShortstate=request.getParameter("pShortstate");
        String pHomepg=request.getParameter("pHomepg");
        String pRes_person_name=request.getParameter("pRes_person_name");
        String pRes_person_tel=request.getParameter("pRes_person_tel");
        String pCom_person_name=request.getParameter("pCom_person_name");
        String pCom_person_tel=request.getParameter("pCom_person_tel");
        //Int pBalance=Integer.parseInt(request.getParameter("pBalance"));
        String pAccount_bank=request.getParameter("pAccount_bank");
        String pAccount_name=request.getParameter("pAccount_name");
        String pAccount_num=request.getParameter("pAccount_num");

        System.out.println(pAddress);
        System.out.println(pShortstate);System.out.println(pHomepg);System.out.println(pRes_person_name);

        PartnersVO p=new PartnersVO();
        Partners_subVO ps=new Partners_subVO();

        p.setPAddress(pAddress);
        ps.setPShortstate(pShortstate); ps.setPHomepg(pHomepg); ps.setPRes_person_name(pRes_person_name);
        ps.setPRes_person_tel(pRes_person_tel); ps.setPCom_person_name(pCom_person_name); ps.setPCom_person_tel(pCom_person_tel);
        //ps.setPBalance(pBalance);
        ps.setPAccount_bank(pAccount_bank); ps.setPAccount_name(pAccount_name); ps.setPAccount_num(pAccount_num);


        String businessNum = (String)session.getAttribute("business_num");
        this.partnersService.updatePartners(businessNum);


        out.println("alert('정보수정에 성공하였습니다.')");
        return "redirect:/partners/data_manage";
    }
    @RequestMapping(value="/pw_change")
    public String pw_change() { return "/partners/mypage/pw_change"; }



}
