/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0370)      VLDCKR(UTC0370_VC)    MSGF(UTMSGF)        */
/*EXI    HLPPNLGRP(MOVMBR)       HLPID(*CMD)                         */
/*EXI *  TEXT('Midas UT Move file members')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       MOVMBR - Move file members                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. BUG27989           Date 08Aug10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK017             Date 21Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 22May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CUP014 *CREATE     Date 12Feb01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG27989 - HATS should run with/without LDAP                */
/*       CPK018 - Release 5 packaging.  Allow for member type of     */
/*                MOVED and SQL types.                               */
/*       CPK017 - 4.01 packaging.  Introduction of DTAQ source type. */
/*       CUP014 - New utility.                                       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Move file member')
 
             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) +
                          PROMPT('File(s)' 1)
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*LIBL) +
                          SPCVAL((*LIBL)) MIN(0) PROMPT('Library')
 
             PARM       KWD(MBR) TYPE(*GENERIC) LEN(10) +
                          SPCVAL((*ALL)) MIN(1) PROMPT('Member(s)' 2)
 
             PARM       KWD(TOLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library for moved member(s)' 3)
 
/************PARM       KWD(MBRTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +                  */ /*CPK015*/
/************             DFT(*ALL) VALUES(*ALL BSCF CLE CLLE CLP +                    */ /*CPK015*/
/************             CMD DSPF DTAARA ICFF LF PF PGM PNLGRP +                      */ /*CPK015*/
/************             PRTF REDUNDANT RPG RPGLE SRVPGM TAPF) +                      */ /*CPK015*/
/************             MIN(0) PMTCTL(*PMTRQS) PROMPT('Member type')                 */ /*CPK015*/
 
/**********  PARM       KWD(MBRTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +                  */ /*CPK017*/
/**********               DFT(*ALL) VALUES(*ALL BSCF CLE CLLE CLP +                    */ /*CPK017*/
/**********               CMD DSPF DTAARA DTAQ ICFF LF PF PGM +                        */ /*CPK017*/
/**********               PNLGRP PRTF REDUNDANT RPG RPGLE SRVPGM +                     */ /*CPK017*/
/**********               TAPF) MIN(0) PMTCTL(*PMTRQS) +                               */ /*CPK017*/
/**********               PROMPT('Member type')                             */ /*CPK015*/ /*CPK017*/
 
/**********  PARM       KWD(MBRTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +                */ /*BUG27989*/
/**********               DFT(*ALL) VALUES(*ALL BSCF CLE CLLE CLP +                  */ /*BUG27989*/
/**********               CMD DSPF DTAARA DTAQ ICFF LF MOVED PF PGM +                */ /*BUG27989*/
/**********               PNLGRP PRTF REDUNDANT RENAMED RPG RPGLE +                  */ /*BUG27989*/
/**********               SQLPROC SQLTBL SQLVIEW SRVPGM TAPF) +                      */ /*BUG27989*/
/**********               MIN(0) PMTCTL(*PMTRQS) PROMPT('Member type'     */ /*CPK017*/ /*BUG27989*/
 
             PARM       KWD(MBRTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*ALL) VALUES(*ALL BSCF CLE CLLE CLP +
                          CMD DSPF DTAARA DTAQ ICFF LF MOVED PF PGM +
                          PNLGRP PRTF REDUNDANT RENAMED RPG RPGLE +
                          SQLDTAARA SQLPROC SQLTBL SQLVIEW SRVPGM +
                          TAPF VLDL) MIN(0) PMTCTL(*PMTRQS) +
                          PROMPT('Member type')                                         /*BUG27989*/
 
             PARM       KWD(LEAVE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) MIN(0) +
                          PMTCTL(*PMTRQS) PROMPT('Leave "from" +
                          member?')
 
             PARM       KWD(CREATE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*NO *YES) MIN(0) +
                          PMTCTL(*PMTRQS) PROMPT('Create file if +
                          not there?')
 
             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*NO *YES) MIN(0) +
                          PMTCTL(*PMTRQS) PROMPT('Replace member if +
                          it exists?')
 
             PARM       KWD(DATE) TYPE(*CHAR) LEN(6) DFT(*ALL) +
                          SPCVAL((*ALL)) MIN(0) PMTCTL(*PMTRQS) +
                          PROMPT('Last changed date (ddmmyy)')
             PARM       KWD(DATESEL) TYPE(*CHAR) LEN(3) RSTD(*YES) +
                          VALUES(*EQ *GT *LT *GE *LE *NE) MIN(0) +
                          PMTCTL(*PMTRQS) PROMPT('Date selection')
 
             DEP        CTL(&DATE *NE '*ALL  ') PARM((&DATESEL *NE +
                          '   ')) MSGID(UT00002)
