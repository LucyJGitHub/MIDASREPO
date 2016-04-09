/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER Audit list')                                 */
/********************************************************************/
/*                                                                   */
/*       Misys - European Reporting - Luxembourg                     */
/*                                                                   */
/*       ERUNQP  - IML AUDIT LIST                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 30Jul05              */
/*                      ULX004             Date 27Oct97        ThL   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*                                                                   */
/*********************************************************************/
     PGM PARM(&IND)
     DCL VAR(&IND) TYPE(*CHAR) LEN(1)
     DCL VAR(&MSG) TYPE(*CHAR) LEN(256)
     DCL VAR(&SENDER) TYPE(*CHAR) LEN(80)
     DCL VAR(&MTIME) TYPE(*CHAR) LEN(6)
 /*  SNDMSG MSG('Audit list being processed') TOMSGQ(ERMSGQ)           ULX004*/
/****SNDMSG*MSG('Audit list being processed') TOMSGQ(CADMSGQ)             */       /*ULX004 CER001*/
     SNDMSG MSG('Audit list being processed') TOMSGQ(MOPERQ)                       /*ULX004 CER001*/
     IF COND(&IND = 'P' *OR &IND = 'N') THEN(DO)
 /*  CHGMSGQ MSGQ(ERMSGQ) RESET(*YES)                                  ULX004*/
/****CHGMSGQ*MSGQ(CADMSGQ)*RESET(*YES)                                    */       /*ULX004 CER001*/
     CHGMSGQ MSGQ(MOPERQ) RESET(*YES)                                                     /*CER001*/
     CHGJOB SWS(XXXXXXX0)
     OVRDBF FILE(TABLE) TOFILE(TABICD)
LOOP: +
 /*  RCVMSG MSGQ(ERMSGQ) RMV(*NO) MSG(&MSG) SENDER(&SENDER)            ULX004*/
/****RCVMSG*MSGQ(CADMSGQ)*RMV(*NO)*MSG(&MSG)*SENDER(&SENDER)              */       /*ULX004 CER001*/
     RCVMSG MSGQ(MOPERQ) RMV(*NO) MSG(&MSG) SENDER(&SENDER)                               /*CER001*/
/****IF COND(&MSG *= ' ') THEN(DO)                                   */                  /*BG18886*/
     IF COND(&MSG *NE ' ') THEN(DO)                                                      /*BG18886*/
     CHGVAR VAR(&MTIME) VALUE(%SUBSTRING(&SENDER 50 6))
     CALL PGM(ERUNQR) PARM(&MSG &MTIME)
     IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
     SNDPGMMSG MSG('Database in error in ERUNQR, File TABLE, Key ''01-
        10''') TOPGMQ(*EXT)
     SNDPGMMSG MSG('Database in error in ERUNQR, File TABLE, Key ''01-
        10''') TOMSGQ(MOPERQ)
     DLTOVR FILE(TABLE)
     RETURN
     ENDDO
     GOTO CMDLBL(LOOP)
     ENDDO
     ELSE CMD(CALL PGM(ERUNQR) PARM('*END*' ' '))
     DLTOVR FILE(TABLE)
     ENDDO
/****IF COND(&IND = 'P' *OR &IND = 'R') THEN(RMVMSG MSGQ(ERMSGQ) -
CLEAR(*ALL))*/
 /*  IF COND(&IND = 'D') THEN(DSPMSG MSGQ(ERMSGQ))                     ULX004*/
/****IF*COND(&IND*=*'D')*THEN(DSPMSG*MSGQ(CADMSGQ))                       */       /*ULX004 CER001*/
     IF COND(&IND = 'D') THEN(DSPMSG MSGQ(MOPERQ))                                        /*CER001*/
     ENDPGM
