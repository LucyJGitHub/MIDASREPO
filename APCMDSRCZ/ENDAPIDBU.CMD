/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    TEXT('Midas AP End the database updaters')                  */
/*E*I****PGM(APCENDDBU)**VLDCKR(*NONE)******MSGF(QCPFMSG)*************/                   /*CPK015*/
/*EXI    PGM(APENDDBU) VLDCKR(*NONE) MSGF(QCPFMSG)                   */                   /*CPK015*/
/*EXI    HLPPNLGRP(ENDAPIDBU)  HLPID(ENDAPIDBU)                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       ENDAPIDBU - End API database updaters                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CSD092             Date 01May13              */
/*       Prev Amend No. CSD093             Date 01Apr13              */
/*                      AR787620           Date 10Jun11              */
/*                      CER059             Date 19Jul10              */
/*                      CER034A            Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CAP183             Date 05Jan06              */
/*                      CGL032             Date 05Jul04              */
/*                      CAS009             Date 04May04              */
/*                      CAP078             Date 31Oct02              */
/*                      CAP077             Date 30Aug02              */
/*                      CAP079             Date 19Aug02              */
/*                      CAP075             Date 12Aug02              */
/*                      CAP076             Date 24May02              */
/*                      CAP074             Date 26Mar02              */
/*                      CAP073             Date 14May02              */
/*                      CSE040             Date 28Mar03              */
/*                      CAP182             Date 14Mar03              */
/*                      CSE039             Date 07Mar03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAP055             Date 13Mar02              */
/*                      CPK015             Date 29May02              */
/*                      CAP072             Date 27Mar02              */
/*                      CAP071             Date 22Mar02              */
/*                      CAP068             Date 22Mar02              */
/*                      CAP069             Date 11Mar02              */
/*                      CAP070             Date 11Mar02              */
/*                      CAS001             Date 23Nov01              */
/*                      CAP067             Date 24Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CAP038             Date 03Mar00              */
/*                      CAP057             Date 03Mar00              */
/*                      CAP042             Date 08Jan01              */
/*                      CAP140             Date 17Oct00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CAP039             Date 14JUL00              */
/*                      CAP137             Date 07Feb00              */
/*                      CAP136             Date 15Nov99              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CAP035             Date 14Apr99              */
/*                      CAP034             Date 14Apr99              */
/*                      CAP031             Date 14Apr99              */
/*                      CAP032             Date 26Apr99              */
/*                      CAP033             Date 26Apr99              */
/*                      173227             Date 05Jan00              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CAP030             Date 16Mar99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP005             Date 15Oct98              */
/*                      CAP004             Date 11Aug98              */
/*                      CAP003             Date 29Jul98              */
/*                      CAP002  *CREATE    Date 01May98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSD092 - Account Review                                     */
/*       CSD093 - Document Management                                */
/*       AR787620 - Hooks Incorporation                              */
/*                  WNCPYSRC,APH00001                                */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER034A - German Features - New Fields and Enquiries        */
/*       CAP183 - Conversion of Market Prices Input into modular     */
/*                structure to use APIs                              */
/*       CGL032 - Automatic Exchange of Information                  */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CAP078 - Lending API enhancements - Fee input               */
/*       CAP077 - Lending API enhancements - Manual repayments       */
/*       CAP079 - Lending API enhancements - Repayments Schedule     */
/*       CAP075 - Lending API enhancements - Loan amendments         */
/*       CAP076 - Lending API enhancements - Rollover Instructions   */
/*       CAP074 - Lending API enhancements - Loans input.            */
/*       CAP073 - Lending API enhancements - Facility Input          */
/*       CSE040 - Securities Statement Processing                    */
/*       CAP182 - Auto Settlement of Trades                          */
/*              - Conversion of SE Trade Settlement Input maintence  */
/*                function to modular structure to use as APIs.      */
/*       CSE039 - Automatic Settlement of Trades                     */
/*       CAP055 - APIs for FRA/IRS Caps/Collars/Floors               */
/*       CPK015 - The called program has been replaced with an RPG   */
/*                as the CL is approaching the IBM parameter limit.  */
/*       CAP072 - Conversion of LE inputs into modular structure to  */
/*                use as APIs - Fee Settlement and Adjustment input  */
/*       CAP071 - Conversion of LE inputs into modular structure to  */
/*                use as APIs - Facility Amendment                   */
/*       CAP068 - Conversion of LE inputs into modular structure to  */
/*                use as APIs - Funding Participants                 */
/*       CAP069 - Conversion of LE inputs into modular structure to  */
/*                use as APIs - Risk Participants                    */
/*       CAP070 - Conversion of LE inputs into modular structure to  */
/*                use as APIs - Assignments                          */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*       CAP067 - Repurchase Agreements API.                         */
/*       CAP038 - Add processing for SD Base Rates Maintenance       */
/*       CAP057 - Add processing for SD Spot Rates Maintenance       */
/*       CAP042 - Conversion of Internal Funding Deal inputs into    */
/*                modular structure to use as APIs.                  */
/*       CAP140 - Conversion of SE Security Diary Event inputs into  */
/*                modular structure to use as APIs.                  */
/*       CAP039 - Add processing for SD SECURITY CUSTOMER DETAILS    */
/*       CAP137 - Conversion of SE Security inputs into modular      */
/*                structure to use as APIs.                          */
/*       CAP136 - Conversion of FT Incoming Payment inputs into      */
/*                modular structure to use as APIs.                  */
/*       CAP035 - Add processing for G/L ACCOUNTS MAINTENANCE        */
/*       CAP034 - Add processing for SD CUSTOMERS DETAILS            */
/*       CAP031 - Add processing for FT Outgoing Payments            */
/*       CAP032 - Conversion of Journal Batch Entry inputs into      */
/*                modular structure to use as APIs.                  */
/*       CAP033 - Conversion of PM inputs into modular structure to  */
/*                use as APIs.                                       */
/*       173227 - Reinstate CAP005                                   */
/*       CAP030 - APIs for SE Price input                            */
/*       CAP005 - Conversion of Midas inputs into modular            */
/*                structure to use as APIs - Phase 4.                */
/*       CAP004 - Conversion of transaction inputs into modular      */
/*                structure to use as APIs - Phase 3.                */
/*       CAP003 - Conversion of transaction inputs into modular      */
/*                structure to use as APIs - Phase 2.                */
/*       CAP002 - Conversion of transaction inputs into modular      */
/*                structure to use as APIs.                          */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('End API database updaters')
 
             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('Midas system prefix')
 
             PARM       KWD(LDNI) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End LDNI job?')
 
             PARM       KWD(DEAM) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End DEAM job?')
 
             PARM       KWD(NASP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End NASP job?')
 
             PARM       KWD(NASS) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End NASS job?')
 
             PARM       KWD(FXDL) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FXDL job?')
 
             PARM       KWD(FRA) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FRA job?')   /*CAP003*/
 
             PARM       KWD(SIRS) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End SIRS job?')  /*CAP003*/
 
             PARM       KWD(CIRS) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End CIRS job?')  /*CAP003*/
 
             PARM       KWD(DPMV) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End DPMV job?')  /*CAP003*/
 
             PARM       KWD(TRAD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End TRAD job?')  /*CAP003*/
 
             PARM       KWD(TRAN) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End TRAN +
                          job?')                                      /*CAP004*/
 
             PARM       KWD(INTC) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End INTC +
                          job?')                                      /*CAP004*/
 
/**********  PARM       KWD(FWRT) TYPE(*CHAR) LEN(1) RSTD(*YES) +                         /*CAP030*/
/**********               DFT(N) VALUES(Y N) PROMPT('End FWRT +                           /*CAP030*/
/**********               job?')                                               /*CAP005*/ /*CAP030*/
 
/**********  PARM       KWD(INTR) TYPE(*CHAR) LEN(1) RSTD(*YES) +                         /*CAP030*/
/**********               DFT(N) VALUES(Y N) PROMPT('End INTR +                           /*CAP030*/
/**********               job?')                                               /*CAP005*/ /*CAP030*/
 
             PARM       KWD(FWRT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FWRT +
                          job?')                                                          /*173227*/
 
             PARM       KWD(INTR) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End INTR +
                          job?')                                                          /*173227*/
 
             PARM       KWD(PRCS) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End PRCS +
                          job?')                                                          /*CAP030*/
 
             PARM       KWD(PFDM) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End PFDM +
                          job?')                                      /*CAP033*/
                                                                      /*CAP033*/
             PARM       KWD(BITH) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End BITH +
                          job?')                                      /*CAP032*/
                                                                      /*CAP032*/
             PARM       KWD(BITP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End BITP +
                          job?')                                      /*CAP032*/
                                                                      /*CAP032*/
 
             PARM       KWD(OPAY) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End OPAY +
                          job?')                                      /*CAP031*/
 
             PARM       KWD(CUSD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End CUSD +
                          job?')                                      /*CAP034*/
 
             PARM       KWD(AMAD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End AMAD +
                          job?')                                      /*CAP035*/
                                                                      /*CAP136*/
             PARM       KWD(IPAY) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End IPAY +
                          job?')                                      /*CAP136*/
                                                                      /*CAP137*/
             PARM       KWD(SECS) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End SECS +
                          job?')                                      /*CAP137*/
             PARM       KWD(SECD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End SECD +
                          job?')                                      /*CAP039*/
 
             PARM       KWD(SEDE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End SEDE +
                          job?')                                                          /*CAP140*/
 
             PARM       KWD(SPTR) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End SPTR +
                          job?')                                                          /*CAP057*/
 
             PARM       KWD(BSRT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End BSRT +
                          job?')                                                          /*CAP038*/
 
             PARM       KWD(FUND) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FUND +
                          job?')                                                          /*CAP042*/
 
             PARM       KWD(REPO) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End REPO +
                          job?')                                                          /*CAP067*/
                                                                                          /*CAP067*/
             PARM       KWD(BYSL) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End BYSL +
                          job?')                                                          /*CAP067*/
                                                                                          /*CAS001*/
             PARM       KWD(YRAT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End YRAT +
                          job?')                                                          /*CAS001*/
 
             PARM       KWD(ASGN) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End ASGN +
                          job?')                                                          /*CAP070*/
 
             PARM       KWD(RPRT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End RPRT +
                          job?')                                                          /*CAP069*/
 
             PARM       KWD(FPRT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FPRT +
                          job?')                                                          /*CAP068*/
 
             PARM       KWD(FAMD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FAMD +
                          job?')                                                          /*CAP071*/
 
             PARM       KWD(FEAD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FEAD +
                          job?')                                                          /*CAP072*/
 
             PARM       KWD(FEST) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FEST +
                          job?')                                                          /*CAP072*/
 
             PARM       KWD(CACF) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End CACF +
                          job?')                                                          /*CAP055*/
 
             PARM       KWD(MVTS) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End MVTS +
                          job?')                                                          /*CSE039*/
 
             PARM       KWD(TRSM) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End TRSM +
                          job?')                                                          /*CAP182*/
 
             PARM       KWD(STPR) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End STPR +
                          job?')                                                          /*CSE040*/
 
             PARM       KWD(FCIP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FCIP +
                          job?')                                                          /*CAP073*/
 
             PARM       KWD(CLIP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End CLIP +
                          job?')                                                          /*CAP074*/
 
             PARM       KWD(LOAM) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End LOAM +
                          job?')                                                          /*CAP075*/
 
             PARM       KWD(LERI) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End LERI +
                          job?')                                                          /*CAP076*/
 
             PARM       KWD(MAPY) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End MAPY +
                          job?')                                                          /*CAP077*/
 
             PARM       KWD(FEEM) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End FEEM +
                          job?')                                                          /*CAP078*/
 
             PARM       KWD(RPSC) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End RPSC +
                          job?')                                                          /*CAP079*/
 
             PARM       KWD(DLFE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End DLFE +
                          job?')                                                          /*CAS009*/
 
             PARM       KWD(ACUD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End ACUD +
                          job?')                                                          /*CGL032*/
 
             PARM       KWD(CCTX) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End CCTX +
                          job?')                                                          /*CGL032*/
 
             PARM       KWD(JACM) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End JACM +
                          job?')                                                          /*CGL032*/
 
             PARM       KWD(NAHL) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End NAHL +
                          job?')                                                          /*CGL032*/
 
             PARM       KWD(NATX) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End NATX +
                          job?')                                                          /*CGL032*/
 
             PARM       KWD(MPRI) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End MPRI +
                          job?')                                                          /*CAP183*/
/*/COPY WNCPYSRC,APH00001                                           */
                                                                                         /*CER034A*/
             PARM       KWD(CUAH) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End CUAH +
                          job?')                                                         /*CER034A*/
             PARM       KWD(DCMT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End DCMT +
                          job?')                                                          /*CSD093*/
                                                                                          /*CSD093*/
             PARM       KWD(ACRV) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('End ACRV +
                          job?')                                                          /*CSD092*/
