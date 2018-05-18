/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FX Netting close of business update')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       FXC0960 - Daily NETS Processing                             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD048795           Date 30Jan18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CDL025             Date 26Jan05              */
/*                      228542             Date 05Aug04              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CDL002             Date 23MAY97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL025 - FX Netting Payment Generation                      */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business         */
/*       CDL002 - FX Netting                                         */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&CNAM &CSEQ)

             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&CDL025) TYPE(*CHAR) LEN(7)               /*CDL025*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                      CCB009*/
/* Declare job name, user and number for remove journal changes         CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
/*                                                                      CDL025*/
/** Check for Switchable feature CDL025.                                CDL025*/
/*                                                                      CDL025*/
             CALL       PGM(AOSARDR0) PARM(&CDL025 '*VERIFY' +
                          'CDL025' &AOFMT)                            /*CDL025*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve current job attributes.                                     CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
             ENDDO                                                    /*CCB009*/

             CHGDTAARA  DTAARA(LDA) VALUE(' ')

             CHGJOB     SWS(XXXXXX00)

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)

             CLRPFM     FILE(FXNTIPPD)

             CLRPFM     FILE(FXNACTPD)

             SNDPGMMSG  MSG('Net Deals File Daily Update') +
                          TOMSGQ(MRUNQ)

/* Call program CB0160 to get value of restart indicator.         */

             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)

/* If it is NOT a restart.                                        */

             IF         COND(&STAT *EQ 'N') THEN(DO)

/* Create journal & receiver   */

                CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)

/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                CHKOBJ     OBJ(&JLIB/JRFXC0960) OBJTYPE(*JRNRCV)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CRTRCV))

                CHKOBJ     OBJ(&JLIB/JFXC0960) OBJTYPE(*JRN)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CRTJRN))

                ENDJRNPF   FILE(*ALL) JRN(JFXC0960)

                GOTO       CMDLBL(JRNFILE)

 CRTRCV:        CRTJRNRCV  JRNRCV(&JLIB/JRFXC0960)

 CRTJRN:        CRTJRN     JRN(&JLIB/JFXC0960) JRNRCV(&JLIB/JRFXC0960)

 JRNFILE:       STRJRNPF   FILE(FXNETMPD) JRN(JFXC0960) IMAGES(*BOTH)

             IF         COND(&CDL025 *EQ '       ') THEN(DO)          /*CDL025*/
                STRJRNPF   FILE(FXNETSPD) JRN(JFXC0960) IMAGES(*BOTH) /*CDL025*/
             ENDDO                                                    /*CDL025*/

             ENDDO                                                    /*CCB009*/
             ENDDO

/* If it is a restart */

             IF         COND(&STAT *EQ 'Y') THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                              CCB009*/
/*                                                                      CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)
/*                                                                      CCB009*/
/* If data area is not blank, calculate the job name, user and number   CCB009*/
/* of the previous run of this component.                               CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10)) +
                                                                      /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6)) +
                                                                      /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of job.                                      CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((FXNETMPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)
                                                                      /*CCB009*/
             IF         COND(&CDL025 *EQ '       ') THEN(DO)          /*CDL025*/
             RMVJRNCHG  JRN(ICJRN) FILE((FXNETSPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CDL025*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)        /*CDL025*/
             ENDDO                                                    /*CDL025*/

             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
                RMVJRNCHG  JRN(JFXC0960) FILE((FXNETMPD))
                MONMSG     (CPF7049)
                                                                      /*CDL025*/
             IF         COND(&CDL025 *EQ '       ') THEN(DO)          /*CDL025*/
                RMVJRNCHG  JRN(JFXC0960) FILE((FXNETSPD))             /*CDL025*/
                MONMSG     (CPF7049)                                  /*CDL025*/
             ENDDO                                                    /*CDL025*/

             ENDDO                                                    /*CCB009*/
             ENDDO

             CHGVAR     VAR(&STAT) VALUE('Y')

/* Call CB0150 to update restart indicator */

             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/* Set U1 to 1 for actual posting in FX0960                                               MD048795*/
             CHGJOB     SWS(1XXXXXXX)                                                   /*MD048795*/
             CALL       PGM(FX0960)

/* Successful completion - delete journal & receiver   */

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* Set U1 back to 0 if no errors occurred                                                 MD048795*/
                CHGJOB     SWS(0XXXXXXX)                                                /*MD048795*/
/* Call CB0150 to update restart indicator */

                CHGVAR     VAR(&STAT) VALUE('N')

                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(*ALL) JRN(JFXC0960)

                DLTJRN     JRN(JFXC0960)

                CHGJOB     INQMSGRPY(*DFT)

                DLTJRNRCV  JRNRCV(JRFXC0960)

                CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/

/**********     RGZPFM     FILE(FXNETMPD)                                                 /*228542*/
/**********     MONMSG     MSGID(CPF2981)                                                 /*228542*/
             CALL       PGM(SCC000060) PARM('FXNETMPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/

             IF         COND(&CDL025 *EQ '       ') THEN(DO)          /*CDL025*/
             CALL       PGM(SCC000060) PARM('FXNETSPD' '*FIRST')      /*CDL025*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*CDL025*/
             ENDDO                                                    /*CDL025*/


             ENDDO

/* Unsuccessful completion - remove journalled changes   */

             ELSE       CMD(DO)

/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve attributes of current job.                                 CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of current job.                              CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((FXNETMPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CDL025*/
             IF         COND(&CDL025 *EQ '       ') THEN(DO)          /*CDL025*/
             RMVJRNCHG  JRN(ICJRN) FILE((FXNETSPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CDL025*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)        /*CDL025*/
             ENDDO                                                    /*CDL025*/
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
                RMVJRNCHG  JRN(JFXC0960) FILE((FXNETMPD))
                MONMSG     (CPF7049)

             IF         COND(&CDL025 *EQ '       ') THEN(DO)          /*CDL025*/
                RMVJRNCHG  JRN(JFXC0960) FILE((FXNETSPD))             /*CDL025*/
                MONMSG     (CPF7049)                                  /*CDL025*/
             ENDDO                                                    /*CDL025*/

                ENDJRNPF   FILE(*ALL) JRN(JFXC0960)

                DLTJRN     JRN(JFXC0960)

                CHGJOB     INQMSGRPY(*DFT)

                DLTJRNRCV  JRNRCV(JRFXC0960)

                CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/

/* Call CB0150 to update restart indicator */

               CHGVAR     VAR(&STAT) VALUE('N')

               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/* Database error processing */

               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                  ROLLBACK
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  GOTO       CMDLBL(END)
               ENDDO
             ENDDO

             GOTO       CMDLBL(END)

 ABNOR:
             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination - batch job */

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FXC0960 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
             ENDPGM
