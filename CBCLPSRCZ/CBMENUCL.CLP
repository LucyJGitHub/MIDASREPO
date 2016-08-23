/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Call COB menu')                              */
/*********************************************************************/
/*                                                                   */
/*       MIDAS - CLOSE OF BUSINESS UTILITIES                         */
/*                                                                   */
/*       CBMENUCL - CL TO CALL CBMENU                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. 207764             Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. 192731             Date 11Jul01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB003             Date 12Dec96              */
/*                      S01408             Date 28NOV95              */
/*                      S01408             DATE 04MAY95              */
/*                      064626             DATE 15DEC93              */
/*                      S01417             DATE 19JUL93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       192731 - Change SAVOBJ cmd to have USEOPTBLK *NO            */
/*                instead of *YES                                    */
/*       CCB003 - Add another menu option                            */
/*       S01408 - Addition of core hook CBMENUCL01                   */
/*       S01408 - Addition of core hook CBMENUCMP1                   */
/*                Addition of core hook CBMENUCMP2                   */
/*       064626 - Library of save file should be specified on SAVOBJ */
/*                command                                            */
/*       S01417 - Adapt Logic to ensure that Component Dependencies  */
/*                are ALWAYS validated when files are updated,       */
/*                either by a Menu Option or <F3> to Exit, and that  */
/*                ALL files used have a back-up secure copy.         */
/*                                                                   */
/*********************************************************************/
                                                                      /*S01417*/
             PGM
                                                                      /*S01417*/
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)               /*S01417*/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(7)                /*S01417*/
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(8)               /*S01417*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)                 /*S01417*/
                                                                      /*S01417*/
             DCL        VAR(&VALFLG) TYPE(*CHAR) LEN(1)               /*S01417*/
             DCL        VAR(&NOTVAL) TYPE(*CHAR) LEN(1)               /*S01417*/
                                                                      /*S01417*/
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(7)  +
                        VALUE('       ')                              /*S01417*/
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(1) VALUE(' ')     /*S01417*/
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(54)               /*S01417*/
                                                                      /*S01417*/
             DCL        VAR(&CBMGFLA8) TYPE(*CHAR) LEN(8)             /*S01417*/
             DCL        VAR(&CBMGFLA10) TYPE(*CHAR) LEN(10)           /*S01417*/
             DCL        VAR(&CBUSRLG)  TYPE(*CHAR) LEN(10)            /*S01417*/
             DCL        VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)             /*S01417*/
                                                                      /*S01417*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*S01417*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*S01417*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*S01417*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*S01417*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*S01417*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*S01417*/
                                                                      /*S01417*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*S01417*/
             DCLF       FILE(*LIBL/CBMENU)                            /*S01417*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/                                                                  /*S01417*/
/**ALLOCATE*THE*CHECKING*FILES*TO*ENSURE*THAT*TWO*USERS               /*S01417*/
/**ARE*NOT*ATTEMPTING*TO*UPDATE*THE*FILES*TOGETHER                    /*S01417*/
/**/                                                                  /*S01417*/
/************ALCOBJ     OBJ((CHKLVLPD *FILE *EXCL)) WAIT(5)           /*S01417*/
/************MONMSG     MSGID(CPF1002) EXEC(DO)                       /*S01417*/
/************    SNDPGMMSG  MSG('The Close of Business Maintenance +  /*S01417*/
/************             Utility is currently being used by +        /*S01417*/
/************             another user. Please retry later.') +       /*S01417*/
/************             TOPGMQ(*EXT)                                /*S01417*/
/************    GOTO       CMDLBL(END)                               /*S01417*/
/************ENDDO                                                    /*S01417*/
/**/
/* IF DATA AREA LDA DOES NOT EXIST IN QTEMP */
/* THEN CREATE IT - USED BY REPORT OPTIONS */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('LOCAL DATA AREA FOR JOB') +
                          AUT(*USE)
             MONMSG     MSGID(CPF1023)
/**/                                                                  /*S01417*/
/* CALL SF0410 TO DETERMINE USER'S LANGUAGE FOR MSGF OVERRIDES */     /*S01417*/
/**/                                                                  /*S01417*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*S01417*/
                                                                      /*S01417*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*S01417*/
                CHGVAR     VAR(&MULT) VALUE('GB')                     /*S01417*/
             ENDDO                                                    /*S01417*/
/**/                                                                  /*S01417*/
/* TERMINATE IF USER NOT FOUND */                                     /*S01417*/
/**/                                                                  /*S01417*/
             IF         COND(&ERRORC *EQ 1) THEN(DO)                  /*S01417*/
                        SNDPGMMSG  MSG('This user is not authorised +
                                   to this Midas system') +
                                   TOPGMQ(*EXT)                       /*S01417*/
                        GOTO       CMDLBL(END)                        /*S01417*/
             ENDDO                                                    /*S01417*/
/**/                                                                  /*S01417*/
/* RETRIEVE DETAILS FOR MSGF OVERRIDES */                             /*S01417*/
/**/                                                                  /*S01417*/
             RTVDTAARA  DTAARA(CBMGFLA) RTNVAR(&CBMGFLA10)            /*S01417*/
             CHGVAR     VAR(&CBMGFLA8) VALUE(%SST(&CBMGFLA10 1 8))    /*S01417*/
             CHGVAR     VAR(&CBUSRLG)  VALUE(&MULT *CAT &CBMGFLA8)    /*S01417*/
             CHGVAR     VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')  /*S01417*/
                                                                      /*S01417*/
             OVRMSGF    MSGF(&CBMGFLA10) TOMSGF(&CBUSRLG)             /*S01417*/
             OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)               /*S01417*/
                                                                      /*S01417*/
/* Retrieve Library Prefix, Concatenate with Library Name             /*S01417*/
                                                                      /*S01417*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBGRP)          /*S01417*/
             CHGVAR     VAR(&DILIB) VALUE(&LIBGRP *TCAT 'DILIB')      /*S01417*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBMENUCMP1                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&DTALIB) VALUE(&LIBGRP *TCAT 'DTALIB')    /*S01417*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBMENUCMP2                                          */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBMENUCL01                                           /*S01408*/
                                                                      /*S01417*/
/* Create Save File                                                   /*S01417*/
                                                                      /*S01417*/
             CRTSAVF    FILE(&DILIB/COBFILES)                         /*S01417*/
             MONMSG     MSGID(CPF7302)                                /*S01417*/
                                                                      /*S01417*/
/* Clear old Save Files                                               /*S01417*/
/* If an old save file exists and not authorised to it, end program   /*S01417*/
                                                                      /*S01417*/
             CLRSAVF    FILE(&DILIB/COBFILES)                         /*S01417*/
             MONMSG     MSGID(CPF9822) EXEC(DO)                       /*S01417*/
                        SNDPGMMSG  MSG('This user is not authorised +
                                   to the save file COBFILES.  To use +
                                   the COB file utilities, authority +
                                   to this file is required.') +
                                   TOPGMQ(*EXT)                       /*S01417*/
                        GOTO       CMDLBL(END)                        /*S01417*/
             ENDDO                                                    /*S01417*/
                                                                      /*S01417*/
/* Save Physical Files                                                /*S01417*/
                                                                      /*S01417*/
/************SAVOBJ     OBJ(CBCMPNPD CBDPRLPD CBMEXCPD CBMDCNPD) +
/************             LIB(&DTALIB) DEV(*SAVF) SAVF(COBFILES)*S01417*064626*/
/**********  SAVOBJ     OBJ(CBCMPNPD CBDPRLPD CBMEXCPD CBMDCNPD) +
/**********               LIB(&DTALIB) DEV(*SAVF) +
/**********               SAVF(&DILIB/COBFILES)                       /*064626 192731*/
/**********  SAVOBJ     OBJ(CBCMPNPD CBDPRLPD CBMEXCPD CBMDCNPD) + */          /*192731*/ /*207764*/
/**********               LIB(&DTALIB) DEV(*SAVF) +                */          /*192731*/ /*207764*/
/**********               SAVF(&DILIB/COBFILES) USEOPTBLK(*NO)     */          /*192731*/ /*207764*/
             SAVOBJ     OBJ(CBCMPNPD CBDPRLPD CBMEXCPD CBMDCNPD) +
                          LIB(&DTALIB) DEV(*SAVF) +
                          SAVF(&DILIB/COBFILES) USEOPTBLK(*NO) +
                          OUTPUT(*PRINT)                                                  /*207764*/
             MONMSG     MSGID(CPF0000)                                /*S01417*/
                                                                      /*S01417*/
/* DISPLAY CBMENU  */
                                                                      /*S01417*/
/**TAG:******GO*********MENU(CBMENU)                                  /*S01417*/
/**/
/************CALL       PGM(CHKCOBCL1)                                /*S01417*/
/**/
                                                                      /*S01417*/
 TAG:        SNDRCVF                                                  /*S01417*/
                                                                      /*S01417*/
/* <F3> Has been pressed. Check whether files have been updated.      /*S01417*/
/* If so, perform File Validation program cycle. End program.         /*S01417*/
                                                                      /*S01417*/
             IF         COND(&IN03 *EQ '1') THEN(DO)                  /*S01417*/
                                                                      /*S01417*/
/* Check whether '&VALFLG' has been switched on, if so call           /*S01417*/
/* validation program cycle.                                          /*S01417*/
                        IF         COND(&VALFLG *EQ 'Y') THEN(DO)     /*S01417*/
                                   CHGVAR    VAR(&LIB) VALUE(&DTALIB) /*S01417*/
                                   CALL      PGM(CHKCOBCL1) +
                                             PARM(&NOTVAL &LIB)       /*S01417*/
/* Check whether Parameter '&NOTVAL' Equals 'Y' (For YES).            /*S01417*/
/* If so display CBMENU again.                                        /*S01417*/
                        IF         COND(&NOTVAL *EQ 'Y') THEN(DO)     /*S01417*/
                                   GOTO       CMDLBL(TAG)             /*S01417*/
                        ENDDO                                         /*S01417*/
/* If CHKCOBCL1 ended abnormally, redisplay CBMENU                    /*S01417*/
                        IF         COND(%SWITCH(XXXXXX11)) THEN(DO)   /*S01417*/
                                   SNDPGMMSG  MSG('An error has   +
                                   occurred whilst validating the +
                                   COB files. Check your joblog for +
                                   further information.')           +
                                   TOPGMQ(*EXT)                       /*S01417*/
                                   CHGJOB     SWS(XXXXXX00)           /*S01417*/
                                   GOTO       CMDLBL(TAG)             /*S01417*/
                        ENDDO                                         /*S01417*/
                        ENDDO                                         /*S01417*/
/* If validation program cycle completed successfully, end program.   /*S01417*/
                        GOTO       CMDLBL(END)                        /*S01417*/
             ENDDO                                                    /*S01417*/
/* Amend COB Components File                                          /*S01417*/
             IF         COND(&OPTION *EQ ' 1' *OR &OPTION *EQ '1 ') +
                        THEN(DO)                                      /*S01417*/
                        CALL       PGM(CB0400D) PARM(&PARM1 &PARM2)   /*S01417*/
                        IF         COND(&PARM2 *EQ 'Y') THEN(DO)      /*S01417*/
                                   CHGVAR     VAR(&VALFLG) VALUE('Y') /*S01417*/
                                   CHGVAR     VAR(&PARM2)  VALUE(' ') /*S01417*/
                        ENDDO                                         /*S01417*/
             ENDDO                                                    /*S01417*/
/* Amend COB Dependencies File                                        /*S01417*/
             IF         COND(&OPTION *EQ ' 2' *OR &OPTION *EQ '2 ') +
                        THEN(DO)                                      /*S01417*/
                        CALL       PGM(CB0410M) PARM(&PARM1 &PARM2)   /*S01417*/
                        IF         COND(&PARM2 *EQ 'Y') THEN(DO)      /*S01417*/
                                   CHGVAR     VAR(&VALFLG) VALUE('Y') /*S01417*/
                                   CHGVAR     VAR(&PARM2)  VALUE(' ') /*S01417*/
                        ENDDO                                         /*S01417*/
             ENDDO                                                    /*S01417*/
/* Amend COB Module Conditions File                                   /*S01417*/
             IF         COND(&OPTION *EQ ' 3' *OR &OPTION *EQ '3 ') +
                        THEN(DO)                                      /*S01417*/
                        CALL       PGM(CB0420M) PARM(&PARM1 &PARM2)   /*S01417*/
                        IF         COND(&PARM2 *EQ 'Y') THEN(DO)      /*S01417*/
                                   CHGVAR     VAR(&VALFLG) VALUE('Y') /*S01417*/
                                   CHGVAR     VAR(&PARM2)  VALUE(' ') /*S01417*/
                        ENDDO                                         /*S01417*/
             ENDDO                                                    /*S01417*/
/* Amend COB Mutually Exclusive Components File                       /*S01417*/
             IF         COND(&OPTION *EQ ' 4' *OR &OPTION *EQ '4 ') +
                        THEN(DO)                                      /*S01417*/
                        CALL       PGM(CB0430M) PARM(&PARM1 &PARM2)   /*S01417*/
                        IF         COND(&PARM2 *EQ 'Y') THEN(DO)      /*S01417*/
                                   CHGVAR     VAR(&VALFLG) VALUE('Y') /*S01417*/
                                   CHGVAR     VAR(&PARM2)  VALUE(' ') /*S01417*/
                        ENDDO                                         /*S01417*/
             ENDDO                                                    /*S01417*/
/* Produce Component Level Report (Dependencies)                      /*S01417*/
             IF         COND(&OPTION *EQ ' 5' *OR &OPTION *EQ '5 ') +
                        THEN(DO)                                      /*S01417*/
                        CALL       PGM(CHKLVLCL)                      /*S01417*/
             ENDDO                                                    /*S01417*/
/* Produce Component Detail Report                                    /*S01417*/
             IF         COND(&OPTION *EQ ' 6' *OR &OPTION *EQ '6 ') +
                        THEN(DO)                                      /*S01417*/
                        CALL       PGM(CBC0200)                       /*S01417*/
             ENDDO                                                    /*S01417*/
/* Produce Component Summary Report                                   /*S01417*/
             IF         COND(&OPTION *EQ ' 7' *OR &OPTION *EQ '7 ') +
                        THEN(DO)                                      /*S01417*/
                        CALL       PGM(CBC0250)                       /*S01417*/
             ENDDO                                                    /*S01417*/
/* Restore original data to COB files and rebuild access paths        /*S01417*/
             IF         COND(&OPTION *EQ ' 8' *OR &OPTION *EQ '8 ') +
                        THEN(DO)                                      /*S01417*/
/**********         RSTOBJ     OBJ(CBCMPNPD CBDPRLPD CBMEXCPD + */             /*S01417*/ /*207764*/
/**********                    CBMDCNPD) SAVLIB(&DTALIB) +      */             /*S01417*/ /*207764*/
/**********                    DEV(*SAVF) SAVF(&DILIB/COBFILES) */             /*S01417*/ /*207764*/
                                                                      /*S01417*/
                    RSTOBJ     OBJ(CBCMPNPD CBDPRLPD CBMEXCPD CBMDCNPD) +
                                 SAVLIB(&DTALIB) DEV(*SAVF) +
                                 SAVF(&DILIB/COBFILES) OUTPUT(*PRINT)                     /*207764*/
                                                                                          /*207764*/
                    CHGVAR VAR(%SST(&PARM3 1 10)) VALUE('CBCMPNPD')   /*S01417*/
                    CHGVAR VAR(%SST(&PARM3 11 20)) VALUE(&DTALIB)     /*S01417*/
                    CALL SDC1763 PARM(&PARM3)                         /*S01417*/
                    IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                           CMDLBL(ABNOR))                             /*S01417*/
                                                                      /*S01417*/
                    CHGVAR VAR(%SST(&PARM3 1 10)) VALUE('CBDPRLPD')   /*S01417*/
                    CALL SDC1763 PARM(&PARM3)                         /*S01417*/
                    IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                           CMDLBL(ABNOR))                             /*S01417*/
                                                                      /*S01417*/
                    CHGVAR VAR(%SST(&PARM3 1 10)) VALUE('CBMEXCPD')   /*S01417*/
                    CALL SDC1763 PARM(&PARM3)                         /*S01417*/
                    IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                           CMDLBL(ABNOR))                             /*S01417*/
                                                                      /*S01417*/
                    CHGVAR VAR(%SST(&PARM3 1 10)) VALUE('CBMDCNPD')   /*S01417*/
                    CALL SDC1763 PARM(&PARM3)                         /*S01417*/
                    IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                           CMDLBL(ABNOR))                             /*S01417*/
                                                                      /*S01417*/
                    CHGVAR     VAR(&VALFLG) VALUE('N')                /*S01417*/
             ENDDO                                                    /*S01417*/
/* Validate COB files                                                 /*S01417*/
             IF         COND(&OPTION *EQ ' 9' *OR &OPTION *EQ '9 ') +
                        THEN(DO)                                      /*S01417*/
                        CHGVAR     VAR(&LIB) VALUE('          ')      /*S01417*/
                        CALL       PGM(CHKCOBCL1) PARM(&NOTVAL &LIB)  /*S01417*/
                        IF         COND(&NOTVAL *EQ 'Y') THEN(DO)     /*S01417*/
                                   CHGVAR     VAR(&VALFLG) VALUE('Y') /*S01417*/
                        ENDDO                                         /*S01417*/
                        IF         COND(&NOTVAL *NE 'Y') THEN(DO)     /*S01417*/
                                   CHGVAR     VAR(&VALFLG) VALUE('N') /*S01417*/
                        ENDDO                                         /*S01417*/
             ENDDO                                                    /*S01417*/
/* Review the guide to using this menu                                /*S01417*/
             IF         COND(&OPTION *EQ '10') THEN(DO)               /*S01417*/
                        DSPDOC     DOC(UTINS) FLR('ABSENG/DBAR3')     /*S01417*/
             ENDDO                                                    /*S01417*/
                                                                      /*S01417*/
/* Access spool files for the job                                     /*S01417*/
             IF         COND(&OPTION *EQ '11') THEN(DO)               /*S01417*/
                        WRKJOB OPTION(*SPLF)                          /*S01417*/
             ENDDO                                                    /*S01417*/
                                                                      /*CCB003*/
/* Display Task Split Components                                      /*CCB003*/
             IF         COND(&OPTION = '12') THEN(DO)                 /*CCB003*/
                                                                      /*CCB003*/
             CALL       PGM(CB0440D) PARM(&PARM1 &PARM2)              /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(&PARM2 = 'Y') THEN(DO)                   /*CCB003*/
             CHGVAR     VAR(&VALFLG) VALUE('Y')                       /*CCB003*/
             CHGVAR     VAR(&PARM2) VALUE(' ')                        /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*S01417*/
/**/
/* IF AN ERROR IS FOUND THEN RETURN TO THE COBMENU */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Press enter to return to the menu and +
                          correct the files') TOPGMQ(*EXT)
             CHGJOB     SWS(XXXXXX00)
             GOTO       CMDLBL(TAG)
             ENDDO
/**/
/* Return to Top of 'TAG' Loop */                                     /*S01417*/
/**/
             GOTO       CMDLBL(TAG)                                   /*S01417*/
/*                                                                    /*S01417*/
/************DLCOBJ     OBJ((CHKLVLPD *FILE *EXCL))                   /*S01417*/
/************DLYJOB     DLY(10)                                       /*S01417*/
/************GOTO       CMDLBL(END)                                   /*S01417*/
/**/
 ABNOR:      SNDPGMMSG  MSG('A database error has occurred whilst +
                          using the COB Menu. Check your job log +
                          for further information.') TOPGMQ(*EXT) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                      /*S01417*/
/*END:       ENDPGM                                                   /*S01417*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01417*/
