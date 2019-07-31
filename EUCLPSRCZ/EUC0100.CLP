/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU Define 'In' ccy to Euro RE a/c mapping')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Retail Utilities                                */
/*                                                                   */
/*       EUC0100 - Define 'In' Ccy to Euro Retail Account Mapping    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 243017             Date 05Jul07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      TDA082             Date 29Mar04              */
/*                      217435             Date 09May03              */
/*                      CRE008             Date 19Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      137365             Date 19JUN98              */
/*                      CEU022  *CREATE    Date 10Dec97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       243017 - Customer number now can be non-numeric.             */
/*       TDA082 - No mapping record created                          */
/*       217435 - Refine mapping to specified A/c Seq. No.           */
/*       CRE008 - Cash Management                                    */
/*       137365 - OMIT CLOSED ACCOUNT                                */
/*       CEU022 - EMU Retail Utilities                               */
/*                                                                   */
/*********************************************************************/
/*********** PGM **************************************/     /*CRE008*/
             PGM        PARM(&EMUM)                          /*CRE008*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DBER) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&PRM1) TYPE(*CHAR) LEN(213)      /*217435*/
/**********  DCL        VAR(&PRM1) TYPE(*CHAR) LEN(216)                         */ /*217435 TDA082*/
             DCL        VAR(&PRM1) TYPE(*CHAR) LEN(226)                                   /*TDA082*/
             DCL        VAR(&PRM2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WBRCA) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&WACOD) TYPE(*CHAR) LEN(4)                                 */ /*TDA082*/
             DCL        VAR(&WACOD) TYPE(*CHAR) LEN(10)                                   /*TDA082*/
             DCL        VAR(&WCNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WCNUA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WCCY1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCCY2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCCY3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCCY4) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCCY5) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCCY6) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCCY7) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCCY8) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCCY9) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WCY10) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SELECT) TYPE(*CHAR) LEN(512)
             DCL        VAR(&EMUM)  TYPE(*CHAR) LEN(1)       /*CRE008*/
             DCL        VAR(&WACSQ) TYPE(*CHAR) LEN(2)       /*217435*/
/*/COPY WNCPYSRC,EUC0100001                                          */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
/*/COPY WNCPYSRC,EUC0100002                                          */
 
/**START:****CALL*******PGM(EU0100) PARM(&PRM1 &PRM2) ***/   /*CRE008*/
 START:      CALL       PGM(EU0100) PARM(&EMUM &PRM1 &PRM2)  /*CRE008*/
/*/COPY WNCPYSRC,EUC0100003                                          */
/**/
/*/COPY WNCPYSRC,EUC0100004                                          */
/*    Error processing                                               */
/*    Retrieve LDA and store values                                  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&DBER) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBER) +
                           TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&PRM2 = '1') THEN(GOTO CMDLBL(END))
 
             OVRDBF     FILE(ACCNTAB) SHARE(*YES)
 
             CHGVAR     VAR(&WBRCA) VALUE(%SUBSTRING(&PRM1 7 3))
/**********  CHGVAR     VAR(&WACOD) VALUE(%SUBSTRING(&PRM1 10 4))                      */ /*TDA082*/
             CHGVAR     VAR(&WCNUM) VALUE(%SUBSTRING(&PRM1 44 6))
             CHGVAR     VAR(&WCCY1) VALUE(%SUBSTRING(&PRM1 14 3))
             CHGVAR     VAR(&WCCY2) VALUE(%SUBSTRING(&PRM1 17 3))
             CHGVAR     VAR(&WCCY3) VALUE(%SUBSTRING(&PRM1 20 3))
             CHGVAR     VAR(&WCCY4) VALUE(%SUBSTRING(&PRM1 23 3))
             CHGVAR     VAR(&WCCY5) VALUE(%SUBSTRING(&PRM1 26 3))
             CHGVAR     VAR(&WCCY6) VALUE(%SUBSTRING(&PRM1 29 3))
             CHGVAR     VAR(&WCCY7) VALUE(%SUBSTRING(&PRM1 32 3))
             CHGVAR     VAR(&WCCY8) VALUE(%SUBSTRING(&PRM1 35 3))
             CHGVAR     VAR(&WCCY9) VALUE(%SUBSTRING(&PRM1 38 3))
             CHGVAR     VAR(&WCY10) VALUE(%SUBSTRING(&PRM1 41 3))
             CHGVAR     VAR(&WACSQ) VALUE(%SUBSTRING(&PRM1 215 2))    /*217435*/
             CHGVAR     VAR(&WACOD) VALUE(%SUBSTRING(&PRM1 217 10))                       /*TDA082*/
 
             IF         COND(&WCNUM *EQ '000000') THEN(DO)
                                                                      /*137365*/
/**********  CHGVAR     VAR(&SELECT) VALUE('BRCA *EQ "' *CAT &WBRCA + /*137365*/
/**********               *CAT '" *AND ACOD *EQ ' *CAT &WACOD *CAT +  /*137365*/
/**********               ' *AND (CCY *EQ "' *CAT &WCCY1 *CAT '" *OR +/*137365*/
/**********               CCY *EQ "' *CAT &WCCY2 *CAT '" *OR CCY +    /*137365*/
/**********               *EQ "' *CAT &WCCY3 *CAT '" *OR CCY *EQ "' + /*137365*/
/**********               *CAT &WCCY4 *CAT '" *OR CCY *EQ "' *CAT +   /*137365*/
/**********               &WCCY5 *CAT '" *OR CCY *EQ "' *CAT &WCCY6 + /*137365*/
/**********               *CAT '" *OR CCY *EQ "' *CAT &WCCY7 *CAT +   /*137365*/
/**********               '" *OR CCY *EQ "' *CAT &WCCY8 *CAT '" *OR + /*137365*/
/**********               CCY *EQ "' *CAT &WCCY9 *CAT '" *OR CCY +    /*137365*/
/**********               *EQ "' *CAT &WCY10 *CAT '")')               /*137365*/
             CHGVAR     VAR(&SELECT) VALUE('BRCA *EQ "' *CAT &WBRCA +
                          *CAT '" *AND RECI *EQ  "D"             +
                                  *AND ACOD *EQ ' *CAT &WACOD *CAT +
                          ' *AND (CCY *EQ "' *CAT &WCCY1 *CAT '" *OR +
                          CCY *EQ "' *CAT &WCCY2 *CAT '" *OR CCY +
                          *EQ "' *CAT &WCCY3 *CAT '" *OR CCY *EQ "' +
                          *CAT &WCCY4 *CAT '" *OR CCY *EQ "' *CAT +
                          &WCCY5 *CAT '" *OR CCY *EQ "' *CAT &WCCY6 +
                          *CAT '" *OR CCY *EQ "' *CAT &WCCY7 *CAT +
                          '" *OR CCY *EQ "' *CAT &WCCY8 *CAT '" *OR +
                          CCY *EQ "' *CAT &WCCY9 *CAT '" *OR CCY +
                          *EQ "' *CAT &WCY10 *CAT '")')               /*137365*/
             ENDDO
             ELSE +
             DO
                                                                      /*137365*/
/**********  CHGVAR     VAR(&SELECT) VALUE('BRCA *EQ "' *CAT &WBRCA + /*137365*/
/**********               *CAT '" *AND ACOD *EQ ' *CAT &WACOD *CAT +  /*137365*/
/**********               ' *AND (CCY *EQ "' *CAT &WCCY1 *CAT '" *OR +/*137365*/
/**********               CCY *EQ "' *CAT &WCCY2 *CAT '" *OR CCY +    /*137365*/
/**********               *EQ "' *CAT &WCCY3 *CAT '" *OR CCY *EQ "' + /*137365*/
/**********               *CAT &WCCY4 *CAT '" *OR CCY *EQ "' *CAT +   /*137365*/
/**********               &WCCY5 *CAT '" *OR CCY *EQ "' *CAT &WCCY6 + /*137365*/
/**********               *CAT '" *OR CCY *EQ "' *CAT &WCCY7 *CAT +   /*137365*/
/**********               '" *OR CCY *EQ "' *CAT &WCCY8 *CAT '" *OR + /*137365*/
/**********               CCY *EQ "' *CAT &WCCY9 *CAT '" *OR CCY +    /*137365*/
/**********               *EQ "' *CAT &WCY10 *CAT '") *AND CNUM *EQ + /*137365*/
/**********               ' *CAT &WCNUM *CAT ' ')                     /*137365*/
                                                                      /*217435*/
             IF         COND(&WACSQ *EQ '00') THEN(DO)                /*217435*/
/*******     CHGVAR     VAR(&SELECT) VALUE('BRCA *EQ "' *CAT &WBRCA +                     /*243017*/
/*******                  *CAT '" *AND RECI *EQ  "D"             +                        /*243017*/
/*******                          *AND ACOD *EQ ' *CAT &WACOD *CAT +                      /*243017*/
/*******                  ' *AND (CCY *EQ "' *CAT &WCCY1 *CAT '" *OR +                    /*243017*/
/*******                  CCY *EQ "' *CAT &WCCY2 *CAT '" *OR CCY +                        /*243017*/
/*******                  *EQ "' *CAT &WCCY3 *CAT '" *OR CCY *EQ "' +                     /*243017*/
/*******                  *CAT &WCCY4 *CAT '" *OR CCY *EQ "' *CAT +                       /*243017*/
/*******                  &WCCY5 *CAT '" *OR CCY *EQ "' *CAT &WCCY6 +                     /*243017*/
/*******                  *CAT '" *OR CCY *EQ "' *CAT &WCCY7 *CAT +                       /*243017*/
/*******                  '" *OR CCY *EQ "' *CAT &WCCY8 *CAT '" *OR +                     /*243017*/
/*******                  CCY *EQ "' *CAT &WCCY9 *CAT '" *OR CCY +                        /*243017*/
/*******                  *EQ "' *CAT &WCY10 *CAT '") *AND CNUM *EQ +                     /*243017*/
/*******                  ' *CAT &WCNUM *CAT ' ')                     /*137365*/          /*243017*/
             CHGVAR     VAR(&SELECT) VALUE('BRCA *EQ "' *CAT &WBRCA +
                          *CAT '" *AND RECI *EQ "D" *AND ACOD *EQ ' +
                          *CAT &WACOD *CAT ' *AND (CCY *EQ "' *CAT +
                          &WCCY1 *CAT '" *OR CCY *EQ "' *CAT &WCCY2 +
                          *CAT '" *OR CCY *EQ "' *CAT &WCCY3 *CAT +
                          '" *OR CCY *EQ "' *CAT &WCCY4 *CAT '" *OR +
                          CCY *EQ "' *CAT &WCCY5 *CAT '" *OR CCY +
                          *EQ "' *CAT &WCCY6 *CAT '" *OR CCY *EQ "' +
                          *CAT &WCCY7 *CAT '" *OR CCY *EQ "' *CAT +
                          &WCCY8 *CAT '" *OR CCY *EQ "' *CAT &WCCY9 +
                          *CAT '" *OR CCY *EQ "' *CAT &WCY10 *CAT +
                          '") *AND CNUM *EQ "' *CAT &WCNUM *CAT '" ')                     /*243017*/
             ENDDO                                                    /*217435*/
             ELSE       CMD(DO)                                       /*217435*/
             CHGVAR     VAR(&SELECT) VALUE('BRCA *EQ "' *CAT &WBRCA +
                          *CAT '" *AND RECI *EQ  "D"             +
                                  *AND ACOD *EQ ' *CAT &WACOD *CAT +
                          ' *AND (CCY *EQ "' *CAT &WCCY1 *CAT '" *OR +
                          CCY *EQ "' *CAT &WCCY2 *CAT '" *OR CCY +
                          *EQ "' *CAT &WCCY3 *CAT '" *OR CCY *EQ "' +
                          *CAT &WCCY4 *CAT '" *OR CCY *EQ "' *CAT +
                          &WCCY5 *CAT '" *OR CCY *EQ "' *CAT &WCCY6 +
                          *CAT '" *OR CCY *EQ "' *CAT &WCCY7 *CAT +
                          '" *OR CCY *EQ "' *CAT &WCCY8 *CAT '" *OR +
                          CCY *EQ "' *CAT &WCCY9 *CAT '" *OR CCY +
                          *EQ "' *CAT &WCY10 *CAT '") *AND CNUM *EQ +
                          ' *CAT &WCNUM *CAT ' *AND ACSQ *EQ ' *CAT +
                          &WACSQ *CAT ' ')                            /*217435*/
             ENDDO                                                    /*217435*/
             ENDDO
 
             IF         COND(%SUBSTRING(&PRM1 50 1) *EQ 'Y') THEN(DO)
             OPNQRYF    FILE((ACCNTAB)) QRYSLT(&SELECT) +
                          KEYFLD((BRCA) (ACOD) (CNUM) (CCY) (ACSQ))
             ENDDO
 
             ELSE +
             DO
             OPNQRYF    FILE((ACCNTAB)) QRYSLT(&SELECT) +
                          KEYFLD((BRCA) (ACOD) (CNUM) (ACSQ))
             ENDDO
 
/*/COPY WNCPYSRC,EUC0100005                                          */
/*********** CALL ******PGM(EU0110) PARM(&PRM1 &PRM2) **/    /*CRE008*/
             CALL       PGM(EU0110) PARM(&EMUM &PRM1 &PRM2)  /*CRE008*/
             CLOF       OPNID(ACCNTAB)
/*/COPY WNCPYSRC,EUC0100006                                          */
/**/
/*    Error processing                                               */
/*    Retrieve LDA and store values                                  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&DBER) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBER) +
                           TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(START)
 
 
/*     Abnormal termination                                          */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Define ''In'' Ccy to Euro account +
                          Mapping Process has ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
/*     Normal termination                                            */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:
             ENDPGM
