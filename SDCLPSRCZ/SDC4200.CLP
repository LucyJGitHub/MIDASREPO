/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD BTS COB update master file')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                        */
/*                                                                   */
/*       Business Transaction Statistics Switchable Feature          */
/*                                                                   */
/*       SDC4200  - SD BTS Update master file                        */
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
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10May95              */
/*                      061963             DATE 03MAR94              */
/*                      S01411             DATE 30APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB009 - Journal files throughout close of business         */
/*       S01408 - Addition of core hook SDC4200MP1                   */
/*       061963 - Default answer when journal receiver not yet saved */
/*       S01411 - New program for BTS                                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/* */
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&EOM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,SDC4200001                                          */
/* */
/** GLOBAL MONITOR */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/* */
/* Change the switches U7 & U8 off */
/* */
             CHGJOB     SWS(XXXXXX00)
/**/
             CHGVAR     VAR(&MSG) VALUE('SDC4200 - BTS Update master +
                          file processing')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/
/**/
/* FIND OUT THE LIBRARY PREFIX FROM DTAARA SDSTAT */
/* */
                 RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
                 CHGVAR     VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2))
                 CHGVAR     VAR(&JLIB) VALUE(&LIBR *TCAT 'JLIB')
                 CHGVAR     VAR(&DPLIB) VALUE(&LIBR *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC4200MP1                                          */
                                                                      /*S01408*/
/**/
/* CALL SD2000 TO DETERMINE WHETHER END OF MONTH */
/**/
             CALL       PGM(SD2000) PARM(&EOM &EOY &ERROR)
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
               CHGVAR     VAR(&PGM) VALUE('SD2000')
               GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/* CALL CB0160 TO FIND OUT THE VALUE OF &STAT, 'Y' = RESTART */
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
/* IF THIS IS A RESTART */
/**/
             IF         COND(&STAT *EQ 'Y') THEN(DO)
/**/
/**/
/* IF IT IS MONTH END SD4201 MAY HAVE BEEN CALLED */
/* */
                IF         COND(&EOM *EQ 'Y') THEN(DO)
/**/
/* IF XSDBTSFPD - THE SECURITY COPY OF SDBTSFPD EXISTS       */
/* COPY BACK THE DATA FROM SECURITY COPY */
/* AND THEN DELETE IT */
/**/
                    CHKOBJ     OBJ(&DPLIB/XSDBTSFPD) OBJTYPE(*FILE)
/*/COPY WNCPYSRC,SDC4200010                                          */
                    MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(JRNCHK))
/*/COPY WNCPYSRC,SDC4200011                                          */
/**/
                    CPYF       FROMFILE(&DPLIB/XSDBTSFPD) TOFILE(SDBTSFPD) +
                                 MBROPT(*REPLACE)
                    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)      +
                                 EXEC(CLRPFM SDBTSFPD)
                    DLTF       FILE(&DPLIB/XSDBTSFPD)
/*/COPY WNCPYSRC,SDC4200012                                          */
/**/
                ENDDO
/**/
JRNCHK:
/**/
/* CHECK EXISTANCE OF JOURNAL SDC4200JRN & */
/* THE JOURNAL RECEIVER SDC4200RCV */
/**/
                CHKOBJ     OBJ(SDC4200JRN) OBJTYPE(*JRN)
                MONMSG     MSGID(CPF9801) EXEC(DO)
/**/
/* IF JOURNAL RECEIVER AND JOURNAL DO NOT EXIST */
/* RESTART THE JOB AT THE CALL TO SD4201 */
/**/
                  CHKOBJ     OBJ(SDC4200RCV) OBJTYPE(*JRNRCV)
                  MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(START))
/**/
                ENDDO
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
/* OTHERWISE END JOURNALLING OF PF/SDBTSMPD */
/* DELETE THE JOURNAL AND THE JOURNAL RECEIVER */
/**/
/*/COPY WNCPYSRC,SDC4200002                                          */
                ENDJRNPF   FILE(SDBTSMPD) JRN(SDC4200JRN)
                MONMSG     MSGID(CPF7032)
/*/COPY WNCPYSRC,SDC4200013                                          */
             ENDDO                                                    /*CCB009*/
                DLTJRN     JRN(&JLIB/SDC4200JRN)
                CHGJOB     INQMSGRPY(*DFT)                            /*061963*/
                DLTJRNRCV  JRNRCV(&JLIB/SDC4200RCV)
                CHGJOB     INQMSGRPY(*RQD)                            /*061963*/
/*/COPY WNCPYSRC,SDC4200003                                          */
/* */
             ENDDO
/* */
/* */
/* THIS IS NOT A RESTART */
/* */
             ELSE DO
/* */
/* RESET THE VALUE OF RESTART FLAG TO 'Y' AND CALL CB0150 */
/* RESTART THE JOB FROM THE BEGINING */
/* */
               CHGVAR     VAR(&STAT) VALUE('Y')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/**/
 START:
/**/
/* CREATE JOURNAL RECEIVER, JOURNAL AND */
/* START JOURNALLING PF/SDBTSMPD */
/**/
/*/COPY WNCPYSRC,SDC4200004                                          */
             CRTJRNRCV  JRNRCV(&JLIB/SDC4200RCV)
             CRTJRN     JRN(&JLIB/SDC4200JRN) JRNRCV(SDC4200RCV)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             STRJRNPF   FILE(SDBTSMPD) JRN(SDC4200JRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
/*/COPY WNCPYSRC,SDC4200014                                          */
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SDC4200005                                          */
/* */
/* COPY THE RECORDS FROM LF/SDBTTDL1 TO PF/SDBTSMPD */
/* */
             CPYF       FROMFILE(SDBTTDL1) TOFILE(SDBTSMPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817 CPF5009) EXEC(DO)
/* */
/* IF CPYF FAILS, THEN ROLLBACK, END JOURNALLING AND */
/* PERFORM STANDARD ABNORMAL PROCESSING */
/* */
               ROLLBACK
               CHGVAR     VAR(&PGM) VALUE('          ')
/*/COPY WNCPYSRC,SDC4200006                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
               ENDJRNPF   FILE(SDBTSMPD) JRN(SDC4200JRN)
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SDC4200007                                          */
               GOTO       CMDLBL(ABNOR)
             ENDDO
/*/COPY WNCPYSRC,SDC4200015                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* */
/* IF CPYF ENDS NORMALLY,  END JOURNALLING, DELETE JOURNAL AND */
/* AND JOURNAL RECEIVER */
/* */
/*/COPY WNCPYSRC,SDC4200008                                          */
             ENDJRNPF   FILE(SDBTSMPD) JRN(SDC4200JRN)
             ENDDO                                                    /*CCB009*/
             DLTJRN     JRN(&JLIB/SDC4200JRN)
             CHGJOB     INQMSGRPY(*DFT)                               /*061963*/
             DLTJRNRCV  JRNRCV(&JLIB/SDC4200RCV)
             CHGJOB     INQMSGRPY(*RQD)                               /*061963*/
/*/COPY WNCPYSRC,SDC4200009                                          */
/**/
/* IF IT IS MONTH END CALL SD4201 - UPDATES MONTHLY FIGURES FILE*/
/* */
             IF         COND(&EOM *EQ 'Y') THEN(DO)
/**/
/**/
/* TAKE SECURITY COPY OF MONTHLY FIGURES DATA */
/**/
               CPYF       FROMFILE(SDBTSFPD) TOFILE(&DPLIB/XSDBTSFPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
/**/
/* PRODUCE NEW MONTHLY FIGURES */
/**/
               CALL       PGM(SD4201)
/**/
/* ABNORMAL PROCESSING IF CALL TO PROGRAM FAILS OR IF DATABASE ERROR */
/**/
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000) CMPDTA(*NONE) +
               EXEC(DO)
                 CHGVAR     VAR(&PGM) VALUE('SD4201')
                 GOTO       CMDLBL(ABNOR)
               ENDDO
 
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 CHGVAR     VAR(&PGM) VALUE('SD4201')
                 GOTO       CMDLBL(ABNOR)
               ENDDO
/**/
/* DELETE SECURITY COPY AS COMPLETED NORMALLY */
/**/
             DLTF       FILE(&DPLIB/XSDBTSFPD)
/*/COPY WNCPYSRC,SDC4200016                                          */
             ENDDO
/* */
/* RESET THE VALUE OF RESTART FLAG TO 'N' AND CALL CB0150 */
/* RESTART THE JOB FROM THE BEGINING */
/* */
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**/
             GOTO       CMDLBL(END)
/**/
/** ABNORMAL ERROR PROCESSING */
/* */
 ABNOR:      CHGVAR     VAR(&MSG) VALUE('Program SDC4200 - ' *CAT +
                          &PGM *BCAT 'ended abnormally')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
