/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas BU SDCURRPD to TBCCY (Leo)')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas Background Update                                 */
/*                                                                   */
/*       BUC0001 -  UPDATE FROM SDCURRPD TO TBCCY (LEO)              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 084197             DATE 12MAY95              */
/*                      S01467             DATE 27MAY94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       084197  -  Validate data integrity before update of LEO's   */
/*                  database. ie. pass parameters 'dec.place' & 'M/D */
/*                  ind.' when calling CATUXR.                       */
/*       S01467  -  Midas-Leo Integration - New program              */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&RTN &CURR &SPTR &BSPR &BSPS &SSPR &SSPS)/*084197*/
             PGM        PARM(&RTN &CURR &SPTR &BSPR &BSPS &SSPR +
                          &SSPS &MDIN &NBDP)                          /*084197*/
 
/** Declare the parameters and variables */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CURR) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SPTR) TYPE(*DEC) LEN(13 8)
             DCL        VAR(&BSPR) TYPE(*DEC) LEN(13 8)
             DCL        VAR(&BSPS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SSPR) TYPE(*DEC) LEN(13 8)
             DCL        VAR(&SSPS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MDIN) TYPE(*CHAR) LEN(1)                 /*084197*/
             DCL        VAR(&NBDP) TYPE(*DEC) LEN(1 0)                /*084197*/
 
/** Global monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Change the switches U7 & U8 off */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Retrieve the Library name for the LEO program CATUXR */
 
             RTVDTAARA  DTAARA(*LDA (51 10)) RTNVAR(&LIB)
 
/** Call the LEO update program CATUXR */
 
/**********  CALL       PGM(&LIB/CATUXR) PARM(&RTN &CURR &SPTR &BSPR +/*084197*/
/**********               &BSPS &SSPR &SSPS)                          /*084197*/
             CALL       PGM(&LIB/CATUXR) PARM(&RTN &CURR &SPTR &BSPR +
                          &BSPS &SSPR &SSPS &MDIN &NBDP)              /*084197*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal error processing */
 
 ABNOR:      SNDPGMMSG  MSG('Program BUC0001 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
