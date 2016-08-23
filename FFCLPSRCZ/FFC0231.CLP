/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FF Close Out Cancellation')                     */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0231  -  POSITION CLOSE OUT CANCELLATION                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. 261143             Date 16Jul09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL007             Date 26Mar99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CFF004             Date 03Oct96              */
/*                      E44676(FUJI-FF0004)DATE 01AUG92              */
/*                  S01117             DATE 21MAR90                  */
/*                  S01240             DATE 12/04/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       261143 - Convert Customer Code (CUSC) and Broker Code       */
/*                (BOCO) to alphanumeric.                            */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CGL007 - Account Postings Enquiry                           */
/*   CFF004  -  Increase in size of Price Fields                     */
/*   E44676      - Automatically update unrealised P&L after         */
/*               - position closeout and trades input.               */
/*   S01117  -  MULTIBRANCHING                                       */
/*   S01240  -  ADDITION OF REAL TIME STATEMENT CHANGES              */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&MARKT)   TYPE(*CHAR)  LEN(3)             /*E44676*/
             DCL        VAR(&SBJOB)   TYPE(*CHAR)  LEN(30)            /*E44676*/
             DCL        VAR(&PMKT) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&BRCD) TYPE(*DEC) LEN(3 0)             */ /*S01117*/
             DCL        VAR(&BRCA) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&ISTT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&YRNO) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MTHN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PCAL) TYPE(*CHAR) LEN(1)
/*********** DCL        VAR(&STRP) TYPE(*DEC) LEN(11 7)               /*CFF004*/
             DCL        VAR(&STRP) TYPE(*DEC) LEN(15 8)               /*CFF004*/
/**********  DCL        VAR(&BOCO) TYPE(*DEC) LEN(6 0) */                                 /*261143*/
/**********  DCL        VAR(&CUSC) TYPE(*DEC) LEN(6 0) */                                 /*261143*/
             DCL        VAR(&BOCO) TYPE(*CHAR) LEN(6)                                     /*261143*/
             DCL        VAR(&CUSC) TYPE(*CHAR) LEN(6)                                     /*261143*/
             DCL        VAR(&BOKC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&COPL) TYPE(*DEC) LEN(13 0)
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLON) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,FFC0231001                                          */
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7)                  /*CGL007*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7)                  /*CGL007*/
             DCL       VAR(&SAR) TYPE(*CHAR) LEN(6)                   /*CGL007*/
             DCL       VAR(&SCSARD) TYPE(*CHAR) LEN(200)              /*CGL007*/
             DCL       VAR(&CGL007) TYPE(*CHAR) LEN(1)                /*CGL007*/
             DCL       VAR(&ACLON) TYPE(*CHAR) LEN(6)                 /*CGL007*/
             DCL       VAR(&MOD) TYPE(*CHAR) LEN(2)                   /*CGL007*/
             DCL       VAR(&RETN) TYPE(*CHAR) LEN(1)                  /*CGL007*/
                                                                      /*CGL007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CGL007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CGL007*/
             CHGVAR     VAR(&SAR) VALUE('CGL007')                     /*CGL007*/
             CHGVAR     VAR(&CGL007) VALUE('N')                       /*CGL007*/
/**/                                                                  /*CGL007*/
/**  Check if Postings Enquiry is installed */                        /*CGL007*/
/**/                                                                  /*CGL007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CGL007*/
                                                                      /*CGL007*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CGL007*/
                  CHGVAR     VAR(&CGL007) VALUE('Y')                  /*CGL007*/
                  CHKOBJ     OBJ(FFCODS) OBJTYPE(*DTAARA)             /*CGL007*/
                  MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SUIT))   /*CGL007*/
                  RTVDTAARA  DTAARA(FFCODS (1 2)) RTNVAR(&MOD)        /*CGL007*/
                  IF         COND(&MOD *EQ "CO") THEN(DO)             /*CGL007*/
                       RTVDTAARA  DTAARA(FFCODS (4 1)) RTNVAR(&ACTN)  /*CGL007*/
                       RTVDTAARA  DTAARA(FFCODS (5 6)) RTNVAR(&ACLON) /*CGL007*/
                       CHGVAR     VAR(&CLON) VALUE(&ACLON)            /*CGL007*/
                  ENDDO                                               /*CGL007*/
             ENDDO                                                    /*CGL007*/
SUIT:                                                                 /*CGL007*/
/**/
/*   CALL POSITION CLOSE OUT CANCELLATION/ENQUIRY PROMPT (FF0070)   */
/**/
U1LOOP:
             OVRDBF     FILE(TABFF) SHARE(*NO)
/**/
/*                                                                 */ /*S01117*/
/*********** CALL       PGM(FF0070) PARM(&BRCD &ISTT &YRNO &MTHN + */ /*S01117*/
/***********              &PCAL &STRP &BOCO &CUSC &BOKC &COPL &PMKT +  *S01117*/
/***********              &ACTN &CLON)                             */ /*S01117*/
             CALL       PGM(FF0070) PARM(&BRCA &ISTT &YRNO &MTHN +
                          &PCAL &STRP &BOCO &CUSC &BOKC &COPL &PMKT +
                          &ACTN &CLON)
/*                                                                 */ /*S01117*/
/**/
/* FOR DATABASE ERRORS OR CMD/1 RETURN TO CALLING COMPONENT          */
/**/
         IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO END)
/**/
         IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO END)
/**/
/*/COPY WNCPYSRC,FFC0231002                                          */
         IF         COND(&CGL007 *EQ "Y" *AND &MOD *EQ "CO" ) +
                    THEN(DO)                                          /*CGL007*/
             RTVDTAARA  DTAARA(FFCODS (3 1)) RTNVAR(&RETN)            /*CGL007*/
             IF         COND(&RETN *NE ' ') THEN(GOTO CMDLBL(END))    /*CGL007*/
          ENDDO                                                       /*CGL007*/
                                                                      /*CGL007*/
         IF         COND(&PMKT *EQ '  ') THEN(DO)
/**/
/*   OVERRIDES FOR FF0080  */
/**/
             OVRDBF  FILE(CLOST) TOFILE(CLOST) MBR(OTC)
             OVRDBF  FILE(CLOST8) TOFILE(CLOST8) MBR(OTC)
             OVRDBF  FILE(TRANS) TOFILE(TRANS) MBR(OTC) SHARE(*NO)
/**/
/*   OVERRIDES FOR FF0320   (CALLED WITHIN FF0080)         */
/**/
             OVRDBF  FILE(CLOST4) TOFILE(CLOST4) MBR(OTC)
             OVRDBF  FILE(CLOST5) TOFILE(CLOST5) MBR(OTC)
             OVRDBF  FILE(CLOST3) TOFILE(CLOST3) MBR(OTC)
             OVRDBF  FILE(MEMOSM) TOFILE(MEMOSM) MBR(OTC)
             OVRDBF  FILE(PRONOM) TOFILE(PRONOM) MBR(OTC)
             OVRDBF  FILE(FFACMVD) TOFILE(FFACMVD) MBR(OTC)           /*S01240*/
             OVRDBF  FILE(POSTNC) TOFILE(POSTNC) MBR(OTC)
             OVRDBF  FILE(POSTNK) TOFILE(POSTNK) MBR(OTC)
             OVRDBF  FILE(TRSETS) TOFILE(TRSET) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(TRSETP) TOFILE(TRSET) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(TRANSS) TOFILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(TRANSP) TOFILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(FOCLTB) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF  FILE(FOCLTC) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF  FILE(DEFLTB) TOFILE(DEFLT) SHARE(*NO)
             OVRDBF  FILE(DEFLTC) TOFILE(DEFLT) SHARE(*NO)
         ENDDO
         ELSE       CMD(DO)
/**/
/*   OVERRIDES FOR FF0080  */
/**/
             OVRDBF  FILE(CLOST) TOFILE(CLOST) MBR(&PMKT)
             OVRDBF  FILE(CLOST8) TOFILE(CLOST8) MBR(&PMKT)
             OVRDBF  FILE(TRANS) TOFILE(TRANS) MBR(&PMKT) SHARE(*NO)
/**/
/*   OVERRIDES FOR FF0320   (CALLED WITHIN FF0080)         */
/**/
             OVRDBF  FILE(CLOST4) TOFILE(CLOST4) MBR(&PMKT)
             OVRDBF  FILE(CLOST5) TOFILE(CLOST5) MBR(&PMKT)
             OVRDBF  FILE(CLOST3) TOFILE(CLOST3) MBR(&PMKT)
             OVRDBF  FILE(MEMOSM) TOFILE(MEMOSM) MBR(&PMKT)
             OVRDBF  FILE(PRONOM) TOFILE(PRONOM) MBR(&PMKT)
             OVRDBF  FILE(FFACMVD) TOFILE(FFACMVD) MBR(&PMKT)         /*S01240*/
             OVRDBF  FILE(POSTNC) TOFILE(POSTNC) MBR(&PMKT)
             OVRDBF  FILE(POSTNK) TOFILE(POSTNK) MBR(&PMKT)
             OVRDBF  FILE(TRSETS) TOFILE(TRSET) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(TRSETP) TOFILE(TRSET) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(TRANSS) TOFILE(TRANS) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(TRANSP) TOFILE(TRANS) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(FOCLTB) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF  FILE(FOCLTC) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF  FILE(DEFLTB) TOFILE(DEFLT) SHARE(*NO)
             OVRDBF  FILE(DEFLTC) TOFILE(DEFLT) SHARE(*NO)
         ENDDO
/**/
/*   CALL POSITION CLOSE OUT CANCELLATION/ENQUIRY (FF0080)          */
/**/
/*                                                                 */ /*S01117*/
/********CALL       PGM(FF0080) PARM(&BRCD &ISTT &YRNO &MTHN &PCAL+*/ /*S01117*/
/*********            &STRP &BOCO &CUSC &BOKC &COPL &PMKT &ACTN +  */ /*S01117*/
/*********            &CLON)                                       */ /*S01117*/
         CALL       PGM(FF0080) PARM(&BRCA &ISTT &YRNO &MTHN &PCAL +
                      &STRP &BOCO &CUSC &BOKC &COPL &PMKT &ACTN +
                      &CLON)
/*                                                                 */ /*S01117*/
/**/
/*   IF OTC NOT USED,DEALLOCATE DATA AREA                           */
/**/
             IF         COND(&PMKT *NE '  ') THEN(DO)
                 DLCOBJ     OBJ((&PMKT *DTAARA *SHRRD))
             ENDDO
             DLTOVR     FILE(*ALL)
/*/COPY WNCPYSRC,FFC0231003                                          */
         IF         COND(&CGL007 *EQ "Y" *AND &MOD *EQ "CO" ) +
                          THEN(GOTO CMDLBL(END))                      /*CGL007*/
/**/                                                                  /*E44676*/
/* Submit job to update unrealised P&L                             */ /*E44676*/
/**/                                                                  /*E44676*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*E44676*/
/*                                                        */          /*E44676*/
/** Pass the market parameter as 'OTC' for OTC's          */          /*E44676*/
/*                                                        */          /*E44676*/
                                                                      /*E44676*/
             IF         COND(&PMKT *EQ '  ') THEN(DO)                 /*E44676*/
                CHGVAR     VAR(&MARKT) VALUE('OTC')                   /*E44676*/
             ENDDO                                                    /*E44676*/
             ELSE       CMD(DO)                                       /*E44676*/
             CHGVAR     VAR(&MARKT) VALUE(&PMKT)                      /*E44676*/
             ENDDO                                                    /*E44676*/
                                                                      /*E44676*/
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(' *CAT +
                          &MARKT *CAT ')')                            /*E44676*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                  /*E44676*/
/************SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +                            /*CSC023*/
/************             JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)  /*E44676*/          /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)      /*E44676*/          /*CSC023*/
             SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +
                          JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
             ENDDO                                                    /*E44676*/
/**/
/* IF U1 IS OFF (CMD/5 TAKEN IN FF0080) GO BACK TO FF0070           */
/**/
             IF         COND(%SWITCH(0XXXXX00)) THEN(GOTO U1LOOP)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*END:*******ENDPGM                                                */ /*E44676*/
/**/                                                                  /*E44676*/
END:                                                                  /*E44676*/
             ENDPGM                                                   /*E44676*/
