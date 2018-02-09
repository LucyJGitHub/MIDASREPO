/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Regular payment generation - non-i/c')       */
/*********************************************************************/
/*                                                                   */
/*       Midas       FUNDS TRANSFER MODULE                       */
/*                                                                   */
/*       FTC0205    REGULAR PAYMENTS GENERATION                      */
/*                  (NON INPUT CYCLE)                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CFT014             Date 25May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E36108             Date 18Feb92              */
/*                      S01117             Date 11Oct90              */
/*                      S01194            DATE  11/10/90             */
/*                                                                   */
/*********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CFT014 - Straight-through Processing Phase 2 MT103          */
/*                Messages Generation for FT.                        */
/*                E36108- CHANGE TO USE NEW LIBRARY SUFFIXES         */
/*                S01194- NEW DATABASE HANDLING                      */
/*                S01117- RCF PROCESSING                             */
/*********************************************************************/
   PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* DCL     VAR(&DATA) TYPE(*CHAR) LEN(44)                             /*S01194*/
   DCL     VAR(&DATA) TYPE(*CHAR) LEN(50)                             /*S01194*/
   DCL     VAR(&LIB)  TYPE(*CHAR) LEN(10)
   DCL     VAR(&PRE)  TYPE(*CHAR) LEN(2)
 
   DCL     VAR(&FTSTAT)  TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,FTC0205001                                          */
/**/                                                                 /*S01194*/
      CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
/**/                                                                 /*S01194*/
 
   SNDPGMMSG MSG('FT0205 - Regular Payments Generation') TOMSGQ(MRUNQ)
 
   ALCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))
             RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)
   IF COND(%SUBSTRING(&FTSTAT 4 1) = 'N') THEN(DO)
 
 
         RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
/*       CHGVAR     VAR(&LIB) VALUE(&PRE *TCAT 'DLIB')           */   /*E36108*/
         CHGVAR     VAR(&LIB) VALUE(&PRE *TCAT 'DPLIB')               /*E36108*/
 
         CPYF       FROMFILE(OTPAYZZ) TOFILE(&LIB/XOTPAYZZ) +
                    MBROPT(*REPLACE)  CRTFILE(*YES)                   /*S03220*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XOTPAYZZ)
         CPYF       FROMFILE(OTPAYDD) TOFILE(&LIB/XOTPAYDD) +
                    MBROPT(*REPLACE)  CRTFILE(*YES)                   /*S03220*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XOTPAYDD)
                                                                      /*CFT014*/
             CPYF       FROMFILE(OTPAYXPD) TOFILE(&LIB/XOTPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*CFT014*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XOTPAYXPD))                            /*CFT014*/
                                                                      /*CFT014*/
/*/COPY WNCPYSRC,FTC0205002                                          */
         CHGVAR VAR(%SUBSTRING(&FTSTAT 4 1)) VALUE('Y')
 
             CHGDTAARA  DTAARA(FTSTAT) VALUE(&FTSTAT)
         DLCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))
         ENDDO
 
   ELSE CMD(DO)
 
 
         CPYF       FROMFILE(XOTPAYZZ) TOFILE(OTPAYZZ) +
                    MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM OTPAYZZ)
         CPYF       FROMFILE(XOTPAYDD) TOFILE(OTPAYDD) +
                    MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM OTPAYDD)
                                                                      /*CFT014*/
             CPYF       FROMFILE(XOTPAYXPD) TOFILE(OTPAYXPD) +
                          MBROPT(*REPLACE)                            /*CFT014*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(OTPAYXPD))                             /*CFT014*/
                                                                      /*CFT014*/
/*/COPY WNCPYSRC,FTC0205003                                          */
   ENDDO
 
   CHGJOB SWS(XXXXXX00)
   CALL PGM(FT0205)
 
   IF COND(%SWITCH(XXXXXX00)) THEN(DO)
         ALCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))
             RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)
         CHGVAR VAR(%SST(&FTSTAT 4 1)) VALUE('N')
         CHGDTAARA  DTAARA(FTSTAT) VALUE(&FTSTAT)
         DLCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))
         DLTF       FILE(XOTPAYZZ)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XOTPAYDD)
         MONMSG MSGID(CPF0000)
                                                                      /*CFT014*/
             DLTF       FILE(XOTPAYXPD)                               /*CFT014*/
             MONMSG     MSGID(CPF0000)                                /*CFT014*/
                                                                      /*CFT014*/
/*/COPY WNCPYSRC,FTC0205004                                          */
   ENDDO
 
   IF COND(%SWITCH(XXXXXX11)) THEN(DO)
/*       RTVDTAARA DTAARA(LDA (134 44)) RTNVAR(&DATA)                 /*S01194*/
         RTVDTAARA DTAARA(LDA (134 50)) RTNVAR(&DATA)                 /*S01194*/
         SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                   TOMSGQ(MOPERQ MRUNQ)
   ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
            ENDPGM
