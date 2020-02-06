/*********************************************************************/
/*OVR    OVRDBF FILE(TMPSPLF) TOFILE(FCTMPPD)                        */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MA Retrieve SPLF attributes')                   */
/*********************************************************************/
/*                                                                   */
/*      Midas - Archiving Module                                 */
/*                                                                   */
/*      MAC0010 - Retrieve SPL file attributes                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 117974             Date 6JAn00               */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      084319             Date 07Mar95              */
/*                     076789           DATE 03OCT94                 */
/*                     066347           DATE 31JAN94                 */
/*                     061198           DATE 24SEP93                 */
/*                     LN0852           DATE 15OCT90                 */
/*                     LN0848           DATE 11OCT90                 */
/*                     LN0736           DATE 12SEP90                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*      117974 - Use API to retrieve splf attributes                 */
/*      084319 - Update page length processing for V3+.              */
/*      076789 - Data area QSS1MRI redundant after V2R3M0.           */
/*               Use API QSZRTVPR to determine system level.         */
/*      066347 - EXTEND CHANGE 061198 TO COVER IBM OPERATING         */
/*               SYSTEM R2.3.                                        */
/*      061198 - SPOOL FILE ATTRIBUTES PAGE LENGTH/WIDTH AND         */
/*               LINES PER INCH ARE HELD IN DIFFRENT POSITIONS       */
/*               ON DIFFERENT IBM RELEASE LEVELS                     */
/*      LN0852 - AMEND ERROR HANDLING.                               */
/*      LN0848 - HOLD THE SPOOL FILE PRODUCED BY WRKSPLFA.           */
/*      LN0736 - CHANGES TO ERROR FLAGS AND MONITOR MESSAGES         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      THIS PROGRAM WILL OBTAIN THE STATUS OF THE PRINTED           */
/*      OUTPUT FROM THE SPOOL FILE ATTRIBUTES AND RETURN TO          */
/*      THE CALLING PROGRAM                                          */
/*                                                                   */
/*********************************************************************/
 PGM        PARM(&SPLF &JNUM &USR &JNAM &SNUM +
                   &fmtp &plen &lpi +
                     &ERR)
 
 DCL        &SPLF  *CHAR  10
 DCL        &JNUM  *CHAR  6
 DCL        &USR   *CHAR  10
 DCL        &JNAM  *CHAR  10
 DCL        &SNUM  *CHAR  4
 
 DCL        &fmtp  *CHAR  10
 DCL        &plen  *CHAR  3
 DCL        &lpi   *CHAR  1
 
 DCL        &ERR   *CHAR  1
 
 DCL        &SPLFA *CHAR  132
 /**/                                                                 /*LN0736*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)                /*LN0736*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)                /*LN0736*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*LN0736*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*LN0736*/
                                                                      /*061198*/
             DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)               /*061198*/
/******      DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7) */ /*076789*/ /*084319*/
             DCL        VAR(&RCVVAR) TYPE(*CHAR) LEN(25)              /*076789*/
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('PRDR0100')                           /*076789*/
             DCL        VAR(&PRDINF) TYPE(*CHAR) LEN(27) +
                          VALUE('*OPSYS *CUR  0000*CODE    ')         /*076789*/
             DCL        VAR(&V2R3) TYPE(*CHAR) LEN(1) VALUE('Y')      /*076789*/
                                                                      /*117974*/
             DCL        VAR(&RCV) TYPE(*CHAR) LEN(1024)               /*117974*/
             DCL        VAR(&SPLSEQB) TYPE(*CHAR) LEN(4)              /*117974*/
             DCL        VAR(&JOBALL) TYPE(*CHAR) LEN(26)              /*117974*/
             DCL        VAR(&LPIB) TYPE(*CHAR) LEN(4)                 /*117974*/
             DCL        VAR(&LPIN) TYPE(*DEC) LEN(3 0)                /*117974*/
             DCL        VAR(&LPIN1) TYPE(*DEC) LEN(1 0)               /*117974*/
             DCL        VAR(&PAGLENB) TYPE(*CHAR) LEN(4)              /*117974*/
             DCL        VAR(&PAGLENN) TYPE(*DEC) LEN(3 0)             /*117974*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
 DCLF       FILE(QTEMP/TMPSPLF)
 
/*********MONMSG     MSGID(RPG0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR)) * *LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*LN0736*/
 
 CHGJOB     SWS(00000000)
                                                                      /*117974*/
             CHGVAR     VAR(&JOBALL) VALUE(&JNAM *CAT &USR *CAT +
                          &JNUM)                                      /*117974*/
             CHGVAR     VAR(%BIN(&SPLSEQB)) VALUE(&SNUM)              /*117974*/
                                                                      /*117974*/
             CHKOBJ     OBJ(QUSRSPLA) OBJTYPE(*PGM)                   /*117974*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDOFAPI))    /*117974*/
                                                                      /*117974*/
             CALL       PGM(QUSRSPLA) PARM(&RCV X'00000400' +
                          'SPLA0100' &JOBALL '                ' +
                          '                ' &SPLF &SPLSEQB)          /*117974*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO ABNOR)               /*117974*/
                                                                      /*117974*/
             CHGVAR     VAR(&FMTP) VALUE(%SST(&RCV 81 10))            /*117974*/
                                                                      /*117974*/
             CHGVAR     VAR(&PAGLENB) VALUE(%SST(&RCV 425 4))         /*117974*/
             CHGVAR     VAR(&PAGLENN) VALUE(%BIN(&PAGLENB))           /*117974*/
             CHGVAR     VAR(&PLEN) VALUE(&PAGLENN)                    /*117974*/
                                                                      /*117974*/
             CHGVAR     VAR(&LPIB) VALUE(%SST(&RCV 173 4))            /*117974*/
             CHGVAR     VAR(&LPIN) VALUE(%BIN(&LPIB))                 /*117974*/
             CHGVAR     VAR(&LPIN) VALUE(&LPIN / 10)                  /*117974*/
             CHGVAR     VAR(&LPIN1) VALUE(&LPIN)                      /*117974*/
             CHGVAR     VAR(&LPI) VALUE(&LPIN1)                       /*117974*/
             GOTO THEEND                                              /*117974*/
ENDOFAPI:                                                             /*117974*/
 
         CLOF       OPNID(TMPSPLF)
                    MONMSG     MSGID(CPF4520)
         DLTF       FILE(QTEMP/TMPSPLF)
                    MONMSG     MSGID(CPF2105 CPF3220)
 
/* Display spool file attributes to a printer file  */
/**if*file*not*found*-terminate*processing*********                  * *LN0736*/
 
         OVRPRTF    FILE(QPDSPSFA) HOLD(*YES)                         /*LN0848*/
         WRKSPLFA   FILE(&SPLF) JOB(&JNUM/&USR/&JNAM) +
                      SPLNBR(&SNUM) OUTPUT(*PRINT)
/********MONMSG*****MSGID(CPF3303 CPF3344 CPF3342) EXEC(DO)          * *LN0736*/
/*******************CHGVAR     VAR(&ERR) VALUE('Y')                  * *LN0736*/
/*******************GOTO       CMDLBL(THEEND)                        * *LN0736*/
/*******************ENDDO                                            * *LN0736*/
/************MONMSG     MSGID(CPF3336) EXEC(DO)                 *LN0736*LN0852*/
             MONMSG     MSGID(CPF3309 CPF3336 CPF3342 CPF3344) +
                          EXEC(DO)                                    /*LN0852*/
                CHGVAR     VAR(&ERR) VALUE('P')                       /*LN0736*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)            /*LN0736*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) /*LN0736*/
                SNDPGMMSG  MSG('MAC0010 Retrieve Spool File +
                             Attributes unable to process spool +
                             File.  See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                           /*LN0736*/
                GOTO       CMDLBL(THEEND)                             /*LN0852*/
                ENDDO                                                 /*LN0736*/
 
/* Clear file:TEMPSPLF In Library:QTEMP                     */
 
         DLTF       FILE(QTEMP/TEMPSPLF)
           MONMSG   MSGID(CPF2105)
 
         CRTPF      FILE(QTEMP/TEMPSPLF) RCDLEN(132) SHARE(*YES) +
                      LVLCHK(*NO)
 
         CPYSPLF    FILE(QPDSPSFA) TOFILE(QTEMP/TEMPSPLF) +
                      SPLNBR(*LAST)
 
/* Determine the machine operating system level */                    /*061198*/
                                                                      /*061198*/
         CALL       PGM(QSZRTVPR) PARM(&RCVVAR X'00000019' +
                      &FORMAT &PRDINF X'00000000')                    /*076789*/
                                                                      /*076789*/
/*    If API not found system is pre-V2R3                          */ /*076789*/
                                                                      /*076789*/
         MONMSG     MSGID(CPF0000) EXEC(DO)                           /*076789*/
         CHGVAR     VAR(&V2R3) VALUE('N')                             /*076789*/
         RTVDTAARA  DTAARA(QSYS/QSS1MRI (1 6)) RTNVAR(&IBMLVL)        /*061198*/
         ENDDO                                                        /*076789*/
                                                                      /*076789*/
         IF         COND(&V2R3 = 'Y') THEN(DO)                        /*076789*/
         CHGVAR     VAR(&IBMLVL) VALUE(%SST(&RCVVAR 20 6))            /*076789*/
         ENDDO                                                        /*076789*/
                                                                      /*061198*/
/*  Copy SPL File atributes to the file TEMPSPLF in QTEMP   +
                                                            +
  >>> record 8 = 'Form Type'                                 */
 
         CPYF       FROMFILE(QTEMP/TEMPSPLF) +
                      TOFILE(QTEMP/TMPSPLF) MBROPT(*REPLACE) +
                      CRTFILE(*YES) FROMRCD(8) TORCD(8) +
                      FMTOPT(*NOCHK)
 
/* If machine is at Version 2 Release 1 */                            /*061198*/
/* >>> record 55 = 'Page Length/width'  */                            /*061198*/
/* >>> record 56 = 'Lines per Inch'     */                            /*061198*/
                                                                      /*061198*/
    IF         COND(&IBMLVL *EQ 'V2R1M0')   THEN(DO)                  /*061198*/
         CPYF       FROMFILE(QTEMP/TEMPSPLF) +
                      TOFILE(QTEMP/TMPSPLF) MBROPT(*ADD) +
                      CRTFILE(*NO) FROMRCD(55) TORCD(56) +
                      FMTOPT(*NOCHK)                                  /*061198*/
         MONMSG MSGID(CPF2817)                                        /*061198*/
    ENDDO                                                             /*061198*/
                                                                      /*061198*/
/**Else,*if*machine*is*at*Version*2*Release*2**/           /*061198*/ /*084319*/
/**or,*if*machine*is*at*Version*2*Release*3****/           /*066347*/ /*084319*/
/* If machine is at Version 2 Release 3 or above */                   /*084319*/
/* >>> record 66 = 'Page Length/width'        */                      /*061198*/
/* >>> record 67 = 'Lines per Inch'           */                      /*061198*/
                                                                      /*061198*/
    ELSE (DO)                                                         /*061198*/
/***IF****     COND(&IBMLVL *EQ 'V2R2M0')   THEN(DO) */        /*061198*066347*/
/***IF****     COND((&IBMLVL *EQ 'V2R2M0') +
/*********       *OR (&IBMLVL *EQ 'V2R3M0')) +
/*********       THEN(DO)                                  /*066347*/ /*084319*/
    IF         COND((&IBMLVL *EQ 'V2R2M0') +
                 *OR (&IBMLVL *EQ 'V2R3M0') +
                 *OR (%SST(&IBMLVL 1 2) *EQ 'V3')) +
                 THEN(DO)                                             /*084319*/
         CPYF       FROMFILE(QTEMP/TEMPSPLF) +
                      TOFILE(QTEMP/TMPSPLF) MBROPT(*ADD) +
                      CRTFILE(*NO) FROMRCD(66) TORCD(67) +
                      FMTOPT(*NOCHK)                                  /*061198*/
         MONMSG MSGID(CPF2817)                                        /*061198*/
    ENDDO                                                             /*061198*/
                                                                      /*061198*/
/**Else,*if*machine*is*at*neither*of*these**/              /*061198*/ /*084319*/
/* Otherwise */                                                       /*084319*/
/* >>> record 51 = 'Page Length/width'                       +
 & >>> record 52 = 'Lines per Inch'                          */
 
    ELSE (DO)                                                         /*061198*/
         CPYF       FROMFILE(QTEMP/TEMPSPLF) +
                      TOFILE(QTEMP/TMPSPLF) MBROPT(*ADD) +
                      CRTFILE(*NO) FROMRCD(51) TORCD(52) +
                      FMTOPT(*NOCHK)
         MONMSG MSGID(CPF2817)
    ENDDO                                                             /*061198*/
    ENDDO                                                             /*061198*/
 
 
/*  Read SPL File atributes file TEMPSPLF in QTEMP          +
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         +
  >>> 'Form Type'                                           */
 
 RCVF
     CHGVAR     VAR(&SPLFA) VALUE(&TMPSPLF)
     CHGVAR     VAR(&fmtp)  VALUE(%SST(&SPLFA 47 10))
 
 RCVF
     CHGVAR  &SPLFA  &TMPSPLF
     CHGVAR  &plen   ('000')
 
     IF      ((%sst(&splfa 49 1)) *ne ' ')  then(DO)
             CHGVAR   &plen   (%SST(&SPLFA 47 3))
             enddo
     Else    IF    ((%sst(&splfa 48 1)) *ne ' ')  then(DO)
                   CHGVAR   (%sst(&plen 2 2))  (%SST(&SPLFA 47 2))
                   enddo
             Else  cmd(CHGVAR (%sst(&plen 3 1))  (%SST(&SPLFA 47 1)))
 
 RCVF
     CHGVAR     VAR(&SPLFA) VALUE(&TMPSPLF)
     CHGVAR     VAR(&lpi)   VALUE(%SST(&SPLFA 47 1))
 
 
/* Delete 'Display spool file attributes' printer file       */
 
         DLTSPLF    FILE(QPDSPSFA) JOB(*) SPLNBR(*LAST)
/********MONMSG     MSGID(CPF3303 CPF3309 CPF3344)                   * *LN0736*/
         GOTO       CMDLBL(THEEND)
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
ABNOR:      CHGVAR     VAR(&ERR) VALUE('Y')
/************MONMSG     MSGID(CPF0000 MCH0000)                       * *LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)               /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
/************SNDPGMMSG  MSG('MAC0010 Retrieve Spool File Attributes +
                          terminated abnormally.  See previous +
                          messages for further information.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)           *LN0736*LN0852*/
             SNDPGMMSG  MSG('MAC0010 Retrieve Spool File Attributes +
                          terminated abnormally.  See previous +
                          messages for further information.  RCF +
                          will retry distribution automatically.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*LN0852*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
 
THEEND:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
            ENDPGM
