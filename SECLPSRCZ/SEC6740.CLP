/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE ER Gen. Trades & Depot Movements')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                       */
/*                                                                   */
/*       SEC6740 - SE ER Generates Trades and Depot Movements        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1089839          Date 19Feb13              */
/*       Prev Amend No. CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      242473             Date 03Oct06             */
/*                      235041             DATE 20Jul05             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 10MAY95             */
/*                      080699             DATE 22DEC94              */
/*                      S01496             DATE 07OCT94              */
/*                      S10978             DATE 30MAY93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1089839 - COBOP and 2.1 source clashes                    */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       242473 - TRADSD cannot be cleared since triggers prevent    */
/*                operation.                                         */
/*       235041 - Add recovery for ETCPOSND and TRADSDX1             */
/*       S01408 - Addition of core hook SEC6740MPS                   */
/*       080699 - Restart processing failure.                        */
/*                The Restart processing is not valid when called    */
/*                from SCC05.                                        */
/*       S01496 - Incorporation of JYSKE Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                To generate Trades for Book records and Depot      */
/*                Movements for all Customer records in Allocation   */
/*                file (SEERALPD) with Nominal Allocated different   */
/*                than zero for all Early Redemptions at             */
/*                Redemption Date, when Status is Authorised.        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&CNAM &CSEQ)  ***************/     /*080699*/
PGM                                                             /*080699*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(65)
/**********  DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)***/     /*080699*/
/**********  DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)***/     /*080699*/
/**********  DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')                       /*CCB023*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
/*********** DCL        VAR(&FEA) TYPE(*CHAR) LEN(1)               */ /*S01496*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10) +
                          VALUE('SEC6840')                                                /*CCB023*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0) VALUE(00001)                       /*CCB023*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CCB023*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                   /*CCB023*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                  /*CCB023*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                     /*CCB023*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                     /*CCB023*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                      /*CCB023*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                  /*CCB023*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                                 /*CCB023*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                                /*CCB023*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                                /*CCB023*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')                         /*CCB023*/
/*/COPY WNCPYSRC,SEC6740001                                          */
 
/*********** RTVDTAARA  DTAARA(LZSTAT (10 1)) RTNVAR(&FEA)         */ /*S01496*/
 
/* Get system ID to build DLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DLIB')     */ /*S01496*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')       /*S01496*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC6740MPS                                          */
                                                                      /*S01408*/
 
/* Send Information Program Message */
             CHGVAR     VAR(&MSG) VALUE('SEC6740 - ER GENERATE +
                          TRADES AND DEPOT MOVEMENTS ')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                                                                                          /*CCB023*/
/* Write current journal sequence number to file SCJSEQPD. */                             /*CCB023*/
                                                                                          /*CCB023*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CCB023*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                            /*CCB023*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                          /*CCB023*/
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,SEC6740002                                          */
/* Retrieve the field indicating a Restart */
/**********  CHGVAR     VAR(&STATUS) VALUE(' ')                                           /*CCB023*/
/**********  CHGVAR     VAR(&STATUS) VALUE('Y')                                /*080699*/ /*CCB023*/
/********    CALL       CB0160 PARM(&CNAM &CSEQ &STATUS) **/          /*080699*/
/**********  CHKOBJ     OBJ(XPOSETD) OBJTYPE(*FILE)                */          /*080699*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&STATUS) +
                          VALUE('N'))                              */          /*080699*/ /*CCB023*/
 
/* Override to SEQONLY(*YES 100) */
/**********  OVRDBF     FILE(XSEERRFPD) SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XSEERALPD) SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XTRADSA)   SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XTRADSD)   SEQONLY(*YES 100)          */                     /*CCB023*/
/*********** OVRDBF     FILE(XCHTRADXC) SEQONLY(*YES 100)          */ /*S01496*/
/**********  OVRDBF     FILE(XDPTMVA)   SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XDPTMVD)   SEQONLY(*YES 100)          */                     /*CCB023*/
/*********** OVRDBF     FILE(XDPTMVDXA) SEQONLY(*YES 100)          */ /*S01496*/
/*********** OVRDBF     FILE(XDPTMVDX0) SEQONLY(*YES 100)          */ /*S01496*/
 
/*********** IF         COND(&FEA *EQ 'Y') THEN(DO)                */ /*S01496*/
/**********     OVRDBF     FILE(XDPTMVDX1) SEQONLY(*YES 100)       */                     /*CCB023*/
/*********** ENDDO                                                 */ /*S01496*/
 
/**********  OVRDBF     FILE(XPOSETA) MBR(POSETA) SEQONLY(*YES 100)*/                     /*CCB023*/
/**********  OVRDBF     FILE(XPOSETD) MBR(POSETD) SEQONLY(*YES 100)*/                     /*CCB023*/
 
             OVRDBF     FILE(SEERRFPD) SEQONLY(*YES 100)
             OVRDBF     FILE(SEERALPD) SEQONLY(*YES 100)
             OVRDBF     FILE(TRADSA)   SEQONLY(*YES 100)
             OVRDBF     FILE(TRADSD)   SEQONLY(*YES 100)
/*********** OVRDBF     FILE(CHTRADXC) SEQONLY(*YES 100)           */ /*S01496*/
             OVRDBF     FILE(DPTMVA)   SEQONLY(*YES 100)
             OVRDBF     FILE(DPTMVD)   SEQONLY(*YES 100)
/*********** OVRDBF     FILE(DPTMVDXA) SEQONLY(*YES 100)           */ /*S01496*/
/*********** OVRDBF     FILE(DPTMVDX0) SEQONLY(*YES 100)           */ /*S01496*/
 
/*********** IF         COND(&FEA *EQ 'Y') THEN(DO)                */ /*S01496*/
                OVRDBF     FILE(DPTMVDX1) SEQONLY(*YES 100)
/*********** ENDDO                                                 */ /*S01496*/
 
             OVRDBF     FILE(POSETA) MBR(POSETA) SEQONLY(*YES 100)
             OVRDBF     FILE(POSETD) MBR(POSETD) SEQONLY(*YES 100)
/*/COPY WNCPYSRC,SEC6740003                                          */
 
/**If*Restart,*Take*Security*Copies**/                                                    /*CCB023*/
/**********  IF         COND(&STATUS = 'Y') THEN(DO)               */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(&DLIB/XSEERRFPD) TOFILE(SEERRFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SEERRFPD))              */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(&DLIB/XSEERALPD) TOFILE(SEERALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SEERALPD))              */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(&DLIB/XTRADSA) TOFILE(TRADSA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(TRADSA))                */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(&DLIB/XTRADSD) TOFILE(TRADSD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */                     /*CCB023*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(TRADSD)) */                                    /*242473*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)    */              /*242473 CCB023*/
/**********  RMVPFTRG FILE(TRADSD)                                 */              /*242473 CCB023*/
/**********  CLRPFM FILE(TRADSD)                                   */              /*242473 CCB023*/
/**********  TRIGZONE FILE(TRADSD) ACTION(*ADDTRIG) TRIGTYPE(*LIVETRIG)*/          /*242473 CCB023*/
/**********  ENDDO                                                 */              /*242473 CCB023*/
 
/**********  CPYF       FROMFILE(&DLIB/XTRADSDX1) TOFILE(TRADSDX1) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*235041 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(TRADSDX1))              */              /*235041 CCB023*/
 
/**********  CPYF       FROMFILE(&DLIB/XETCPOSND) TOFILE(ETCPOSND) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*235041 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(ETCPOSND))              */              /*235041 CCB023*/
 
/*********** CPYF       FROMFILE(&DLIB/XCHTRADXC) TOFILE(CHTRADXC) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*S01496*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(CHTRADXC))              */ /*S01496*/
 
/**********  CPYF       FROMFILE(&DLIB/XDPTMVA) TOFILE(DPTMVA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(DPTMVA))                */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(&DLIB/XDPTMVD) TOFILE(DPTMVD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */                     /*CCB023*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(DPTMVD)) */                                    /*242473*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)                    /*242473 CCB023*/
/**********  RMVPFTRG FILE(DPTMVD)                                                 /*242473 CCB023*/
/**********  CLRPFM FILE(DPTMVD)                                                   /*242473 CCB023*/
/**********  TRIGZONE FILE(DPTMVD) ACTION(*ADDTRIG) TRIGTYPE(*LIVETRIG)            /*242473 CCB023*/
/**********  ENDDO                                                                 /*242473 CCB023*/
 
/*********** CPYF       FROMFILE(&DLIB/XDPTMVDXA) TOFILE(DPTMVDXA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*S01496*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(DPTMVDXA))              */ /*S01496*/
 
/*********** CPYF       FROMFILE(&DLIB/XDPTMVDX0) TOFILE(DPTMVDX0) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*S01496*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(DPTMVDX0))              */ /*S01496*/
 
/*********** IF         COND(&FEA *EQ 'Y') THEN(DO)                */ /*S01496*/
/**********      CPYF       FROMFILE(&DLIB/XDPTMVDX1) TOFILE(DPTMVDX1) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)         */                     /*CCB023*/
/**********      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                            EXEC(CLRPFM FILE(DPTMVDX1))            */                     /*CCB023*/
/*********** ENDDO                                                 */ /*S01496*/
 
/**********  CPYF       FROMFILE(&DLIB/XPOSETA) TOFILE(POSETA) +
                          FROMMBR(POSETA) TOMBR(POSETA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETA) MBR(POSETA))                */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(&DLIB/XPOSETD) TOFILE(POSETD) +
                          FROMMBR(POSETD) TOMBR(POSETD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETD) MBR(POSETD))                */                     /*CCB023*/
/*/COPY WNCPYSRC,SEC6740004                                          */
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**********  ELSE CMD(DO)                                          */                     /*CCB023*/
 
/**Delete*Copy*Files************************************************/           /*CCB023 AR1089839*/
/**********  DLTF       FILE(XSEERRFPD)                            */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XSEERALPD)                            */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XTRADSA)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XTRADSD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XTRADSDX1)                            */              /*235041 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*235041 CCB023*/
/**********  DLTF       FILE(XETCPOSND)                            */              /*235041 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*235041 CCB023*/
/*********** DLTF       FILE(XCHTRADXC)                            */ /*S01496*/
/*********** MONMSG MSGID(CPF0000)                                 */ /*S01496*/
/**********  DLTF       FILE(XDPTMVA)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XDPTMVD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/*********** DLTF       FILE(XDPTMVDXA)                            */ /*S01496*/
/*********** MONMSG MSGID(CPF0000)                                 */ /*S01496*/
/*********** DLTF       FILE(XDPTMVDX0)                            */ /*S01496*/
/*********** MONMSG MSGID(CPF0000)                                 */ /*S01496*/
 
/*********** IF         COND(&FEA *EQ 'Y') THEN(DO)                */ /*S01496*/
/**********     DLTF       FILE(XDPTMVDX1)                         */                     /*CCB023*/
/**********     MONMSG MSGID(CPF0000)                              */                     /*CCB023*/
/*********** ENDDO                                                 */ /*S01496*/
 
/**********  DLTF       FILE(XPOSETA)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XPOSETD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/*/COPY WNCPYSRC,SEC6740005                                          */
 
/**Backup*File**/                                                                         /*CCB023*/
/**********  CPYF       FROMFILE(SEERRFPD) TOFILE(&DLIB/XSEERRFPD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(SEERALPD) TOFILE(&DLIB/XSEERALPD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(TRADSA) TOFILE(&DLIB/XTRADSA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(TRADSD) TOFILE(&DLIB/XTRADSD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(TRADSDX1) TOFILE(&DLIB/XTRADSDX1) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*235041 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*235041 CCB023*/
 
/**********  CPYF       FROMFILE(ETCPOSND) TOFILE(&DLIB/XETCPOSND) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*235041 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*235041 CCB023*/
 
/*********** CPYF       FROMFILE(CHTRADXC) TOFILE(&DLIB/XCHTRADXC) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */ /*S01496*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */ /*S01496*/
 
/**********  CPYF       FROMFILE(DPTMVA) TOFILE(&DLIB/XDPTMVA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(DPTMVD) TOFILE(&DLIB/XDPTMVD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */                     /*CCB023*/
 
/*********** CPYF       FROMFILE(DPTMVDXA) TOFILE(&DLIB/XDPTMVDXA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */ /*S01496*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */ /*S01496*/
 
/*********** CPYF       FROMFILE(DPTMVDX0) TOFILE(&DLIB/XDPTMVDX0) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */ /*S01496*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */ /*S01496*/
 
/*********** IF         COND(&FEA *EQ 'Y') THEN(DO)                */ /*S01496*/
/**********     CPYF       FROMFILE(DPTMVDX1) TOFILE(&DLIB/XDPTMVDX1) +
                     MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  */                     /*CCB023*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)          */                     /*CCB023*/
/*********** ENDDO                                                 */ /*S01496*/
 
/**********  CPYF       FROMFILE(POSETA) TOFILE(&DLIB/XPOSETA) +
                          FROMMBR(POSETA) TOMBR(POSETA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)*/                  /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */                     /*CCB023*/
 
/**********  CPYF       FROMFILE(POSETD) TOFILE(&DLIB/XPOSETD) +
                          FROMMBR(POSETD) TOMBR(POSETD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)*/                  /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */                     /*CCB023*/
/*/COPY WNCPYSRC,SEC6740006                                          */
 
/*********** CHGVAR     VAR(&STATUS) VALUE('Y')  **********/          /*080699*/
/*********** CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)****/    /*080699*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/*********** DLTOVR     FILE(XSEERRFPD XSEERALPD XTRADSA XTRADSD +
                          XCHTRADXC XDPTMVA XDPTMVD XDPTMVDXA +
                          XDPTMVDX0 SEERRFPD SEERALPD TRADSA TRADSD +
                          CHTRADXC DPTMVA DPTMVD DPTMVDXA DPTMVDX0 +
                          POSETA POSETD XPOSETA XPOSETD)           */ /*S01496*/
/**********  DLTOVR     FILE(XSEERRFPD XSEERALPD XTRADSA XTRADSD +
                          XDPTMVA XDPTMVD SEERRFPD SEERALPD TRADSA +
                          TRADSD DPTMVA DPTMVD POSETA POSETD XPOSETA +
                          XPOSETD)                                 */              /*S01496 CCB023*/
 
/*********** IF         COND(&FEA *EQ 'Y') THEN(DO)                */ /*S01496*/
/**********       DLTOVR     FILE(XDPTMVDX1 DPTMVDX1)              */                     /*CCB023*/
/*********** ENDDO                                                 */ /*S01496*/
 
/*/COPY WNCPYSRC,SEC6740007                                          */
/* Call the Program */
             OVRDBF FILE(ETCPOSL0) SHARE(*NO)                    /*235041*/
             OVRDBF FILE(ETCPOSL3) SHARE(*NO)                    /*235041*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)              /*235041*/
             MONMSG     MSGID(CPF8351)                           /*235041*/
             CALL       PGM(SE6740)
 
/* For Database Errors Recover Data from LDA */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                           MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)*/ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                           MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)   /*S01496*/
                CHGVAR     VAR(&MEM) VALUE('SEC6740 - JOB TERMINATED, +
                           DATABASE IN ERROR')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                CHGVAR     VAR(&ERROR) VALUE('Y')                                         /*CCB023*/
                GOTO ENDPGM
             ENDDO
 
/* For File in Balance Error */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MEM) VALUE('SEC6740 - FILE CONTROLS OUT +
                          OF BALANCE')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                CHGVAR     VAR(&ERROR) VALUE('Y')                                         /*CCB023*/
                GOTO ENDPGM
             ENDDO
 
/**If*the*job*is*completed*normally**/                                                    /*CCB023*/
/**********  CHGVAR     VAR(&STATUS) VALUE('N')               **/     /*080699*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS) **/     /*080699*/
 
/**Delete*Security*Copy**/                                                                /*CCB023*/
/**********  DLTF       FILE(&DLIB/XSEERRFPD)                      */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(&DLIB/XSEERALPD)                      */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(&DLIB/XTRADSA)                        */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(&DLIB/XTRADSD)                        */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(&DLIB/XTRADSDX1)                      */              /*235041 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*235041 CCB023*/
/**********  DLTF       FILE(&DLIB/XETCPOSND)                      */              /*235041 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*235041 CCB023*/
/*********** DLTF       FILE(&DLIB/XCHTRADXC)                      */ /*S01496*/
/*********** MONMSG MSGID(CPF0000)                                 */ /*S01496*/
/**********  DLTF       FILE(&DLIB/XDPTMVA)                        */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(&DLIB/XDPTMVD)                        */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/*********** DLTF       FILE(&DLIB/XDPTMVDXA)                      */ /*S01496*/
/*********** MONMSG MSGID(CPF0000)                                 */ /*S01496*/
/*********** DLTF       FILE(&DLIB/XDPTMVDX0)                      */ /*S01496*/
/*********** MONMSG MSGID(CPF0000)                                 */ /*S01496*/
 
/*********** IF         COND(&FEA *EQ 'Y') THEN(DO)                */ /*S01496*/
/**********     DLTF       FILE(&DLIB/XDPTMVDX1)                   */                     /*CCB023*/
/**********     MONMSG MSGID(CPF0000)                              */                     /*CCB023*/
/*********** ENDDO                                                 */ /*S01496*/
 
/**********  DLTF       FILE(&DLIB/XPOSETA)                        */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(&DLIB/XPOSETD)                        */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/*/COPY WNCPYSRC,SEC6740008                                          */
 
             RCLRSC
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                                          /*CCB023*/
             IF         COND(&ERROR *EQ 'Y') THEN(DO)                                     /*CCB023*/
                                                                                          /*CCB023*/
/* If abnormal, retrieve attributes of current job. */                                    /*CCB023*/
                                                                                          /*CCB023*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                    /*CCB023*/
                                                                                          /*CCB023*/
/* Retrieve the most recent journal entry sequence number */                              /*CCB023*/
/* for the specific job. */                                                               /*CCB023*/
                                                                                          /*CCB023*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                               /*CCB023*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                   /*CCB023*/
             CHGVAR     VAR(&START) VALUE(0)                                              /*CCB023*/
             ENDDO                                                                        /*CCB023*/
                                                                                          /*CCB023*/
/* Determine starting journal sequence number of current job. */                          /*CCB023*/
                                                                                          /*CCB023*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                   /*CCB023*/
                                                                                          /*CCB023*/
/* Remove journal changes. */                                                             /*CCB023*/
                                                                                          /*CCB023*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                        /*CCB023*/
             RMVJRNCHG  JRN(ICJRN) FILE((SEERRFPD) (SEERALPD) +
                          (TRADSA) (TRADSD) (DPTMVA) (DPTMVD) +
                          (DPTMVDX1) (POSETA) (POSETD)) +
                          FROMENT(&START) TOENT(&FINISH) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR)                                     /*CCB023*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                            /*CCB023*/
             ENDDO                                                                        /*CCB023*/
 
             ENDDO
                                                                                          /*CCB023*/
/* Write current journal sequence number to file SCJSEQPD. */                             /*CCB023*/
                                                                                          /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CCB023*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CCB023*/
 
             ENDPGM
