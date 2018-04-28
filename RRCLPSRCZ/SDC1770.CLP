/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Rmv Members From Multimember Files')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1770  - REMOVE MEMBERS FROM MULTI MEMBER FILES          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01319             DATE 20SEP91             */
/*       PREV AMEND NO. S01179            DATE 13/09/88             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*      S01319  -  Remove redundant processing                      */
/*      S01179  -  AS400 CONVERSION                                 */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
PGM
/**********  DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/* GET MMOD DATA AREA */
/**********  RCVDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/* FX PROCESSING */
             IF         COND(%SST(&MMOD 13 1) *EQ 'Y') THEN(DO)
/***************RMVM*******FILE(FXDWNBLL)*MBR(*ALL)*****************/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)***************************/ /*S01319*/
/***************RMVM*******FILE(FXDWN2LL)*MBR(*ALL)*****************/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)***************************/ /*S01319*/
/***************RMVM*******FILE(FXDW38LL)*MBR(*ALL)*****************/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)***************************/ /*S01319*/
/***************RMVM*******FILE(FXPBLTLL)*MBR(*ALL)*****************/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)***************************/ /*S01319*/
/***************RMVM*******FILE(FXSTDDLL)*MBR(*ALL)*****************/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)***************************/ /*S01319*/
                RMVM       FILE(FXTTOTLL) MBR(*ALL)
                MONMSG     MSGID(CPF0000)
/***************RMVM*******FILE(FXSTDDPP)*MBR(*ALL)*****************/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)***************************/ /*S01319*/
/***************RMVM*******FILE(FXDWNBPP)*MBR(*ALL)*****************/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)***************************/ /*S01319*/
                RMVM       FILE(FXTTOTPP) MBR(*ALL)
                MONMSG     MSGID(CPF0000)
             ENDDO
/* SKIP TO END OF PROGRAM */
             GOTO       CMDLBL(END)
 ABNOR:      SNDPGMMSG  MSG('Addition of logical file members ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
END:          ENDPGM
