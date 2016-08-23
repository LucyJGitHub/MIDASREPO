/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC copy in temporary file members')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2090  - U.D.C. Copy in temporary file members            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD031804           Date 23Jun15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 207764             Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731             Date 11Jul01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      108270             Date 04NOV96              */
/*                      100879             DATE 10JUL96              */
/*                      083768             DATE 16FEB94              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  On-Call Details                                                  */
/*                                                                   */
/*  If component crashes due to unique keys change B0RECI on         */
/*  CGCOBLPD to '*' for the member which fails to copy. This will    */
/*  cause this member to be skipped on re-run.                       */
/*                                                                   */
/*  The data will be kept for one day in EXCGU* files and CGSAVF     */
/*  save file                                                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD031804 - Avoid component failure due to SAVF locked.      */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       192731 - Change SAVOBJ cmd to have USEOPTBLK *NO            */
/*                instead of *YES                                    */
/*       108270 - Prevent duplicate keys in file EXCGUDCRPD.         */
/*       100879 - Prevent duplicate record if wrong extract with     */
/*                item ref. 0 (see CG4610 where suppress conf. have  */
/*                generated data records)                            */
/*       083768 - Loop again as there may be more than one member    */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
/* */
             DCLF       FILE(CGCOBLL0)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2090 - U.D.C. Copy in temporary file +
                          contents') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Format DILIB name */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
/* */
/* Format DMLIB name */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&DBPREFIX *CAT 'DMLIB')
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* If status is active - Perform recovery */
/* */
             IF         COND(&STATUS *NE 'N') THEN(DO)
/* */
/* Restore CGU* Files from CGSAVF */
/* */
/**********  RSTOBJ     OBJ(CGUDCRPD CGUDCLPD CGUDTAPD CGUDT1PD + */                      /*207764*/
/**********               CGUDT2PD CGUDT3PD) SAVLIB(&DMLIB) +     */                      /*207764*/
/**********               DEV(*SAVF) SAVF(&DILIB/CGSAVF)          */                      /*207764*/
             RSTOBJ     OBJ(CGUDCRPD CGUDCLPD CGUDTAPD CGUDT1PD +
                          CGUDT2PD CGUDT3PD) SAVLIB(&DMLIB) +
                          DEV(*SAVF) SAVF(&DILIB/CGSAVF) OUTPUT(*PRINT)                   /*207764*/
/* */
             ENDDO
             ELSE       CMD(DO)
/* */
/* Delete and Create Save file CGSAVF */
/* */
             DLTF       FILE(&DILIB/CGSAVF)
             MONMSG     MSGID(CPF2105)
/* */
             CRTSAVF    FILE(&DILIB/CGSAVF) TEXT('Save file for UDC')
/* */
/* Save CGU* Files from CGSAVF */
/* */
RETRY:                                                                                  /*MD031804*/
/**********  SAVOBJ     OBJ(CGUDCRPD CGUDCLPD CGUDTAPD CGUDT1PD +
/**********               CGUDT2PD CGUDT3PD) LIB(&DMLIB) DEV(*SAVF) +
/**********               SAVF(&DILIB/CGSAVF) ACCPTH(*YES)                            /*192731*/
/**********  SAVOBJ     OBJ(CGUDCRPD CGUDCLPD CGUDTAPD CGUDT1PD +         */
/**********               CGUDT2PD CGUDT3PD) LIB(&DMLIB) DEV(*SAVF) +     */
/**********               SAVF(&DILIB/CGSAVF) ACCPTH(*YES) USEOPTBLK(*NO) */   /*192731*/ /*207764*/
             SAVOBJ     OBJ(CGUDCRPD CGUDCLPD CGUDTAPD CGUDT1PD +
                          CGUDT2PD CGUDT3PD) LIB(&DMLIB) DEV(*SAVF) +
                          SAVF(&DILIB/CGSAVF) USEOPTBLK(*NO) +
                          ACCPTH(*YES) OUTPUT(*PRINT)                                     /*207764*/
             MONMSG     MSGID(CPF3812) EXEC(DO)                                         /*MD031804*/
             DLYJOB     DLY(5)                                                          /*MD031804*/
             GOTO       CMDLBL(RETRY)                                                   /*MD031804*/
             ENDDO       /*MD031804*/
/* */
             ENDDO
/* */
/* Update status to Active */
/* */
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Process each Log record */
/* */
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDL))
/* */
/* If record deleted skip but set save extract and save file to Y */
/* */
             IF         COND(&B0RECI *EQ '*') THEN(DO)
             CHGDTAARA  DTAARA(CGDTA (17 2)) VALUE(YY)
             GOTO       CMDLBL(LOOP)
             ENDDO
/* */
/************CPYF       FROMFILE(EXCGUDCRPD) TOFILE(CGUDCRPD) +       /*100879*/
/************             FROMMBR(&B0MBR) MBROPT(*ADD)                /*100879*/
/************CPYF       FROMFILE(EXCGUDCLPD) TOFILE(CGUDCLPD) +       /*100879*/
/************             FROMMBR(&B0MBR) MBROPT(*ADD)                /*100879*/
/************CPYF       FROMFILE(EXCGUDTAPD) TOFILE(CGUDTAPD) +       /*100879*/
/************             FROMMBR(&B0MBR) MBROPT(*ADD)                /*100879*/
/************CPYF       FROMFILE(EXCGUDT1PD) TOFILE(CGUDT1PD) +       /*100879*/
/************             FROMMBR(&B0MBR) MBROPT(*ADD)                /*100879*/
/************CPYF       FROMFILE(EXCGUDT2PD) TOFILE(CGUDT2PD) +       /*100879*/
/************             FROMMBR(&B0MBR) MBROPT(*ADD)                /*100879*/
/************CPYF       FROMFILE(EXCGUDT3PD) TOFILE(CGUDT3PD) +       /*100879*/
/************             FROMMBR(&B0MBR) MBROPT(*ADD)                /*100879*/
                                                                      /*100879*/
/************CPYF       FROMFILE(EXCGUDCRPD) TOFILE(CGUDCRPD) +       /*108270*/
/************             FROMMBR(&B0MBR) MBROPT(*ADD) INCREL((*IF +  /*108270*/
/************             DRITEM *NE 0))                      /*100879* 108270*/
             OPNQRYF    FILE((EXCGUDCRPD &B0MBR)) QRYSLT('dritem *ne +
                          0') KEYFLD((DRITEM) (DRDCOR)) +
                          UNIQUEKEY(*ALL) /*108270*/
             CPYFRMQRYF FROMOPNID(EXCGUDCRPD) TOFILE(CGUDCRPD) +
                          MBROPT(*ADD)                                /*108270*/
             CLOF       OPNID(EXCGUDCRPD)                             /*108270*/
             CPYF       FROMFILE(EXCGUDCLPD) TOFILE(CGUDCLPD) +
                          FROMMBR(&B0MBR) MBROPT(*ADD) INCREL((*IF +
                          DLITEM *NE 0))                              /*100879*/
             CPYF       FROMFILE(EXCGUDTAPD) TOFILE(CGUDTAPD) +
                          FROMMBR(&B0MBR) MBROPT(*ADD) INCREL((*IF +
                          DEITEM *NE 0))                              /*100879*/
             CPYF       FROMFILE(EXCGUDT1PD) TOFILE(CGUDT1PD) +
                          FROMMBR(&B0MBR) MBROPT(*ADD) INCREL((*IF +
                          DEITEM *NE 0))                              /*100879*/
             CPYF       FROMFILE(EXCGUDT2PD) TOFILE(CGUDT2PD) +
                          FROMMBR(&B0MBR) MBROPT(*ADD) INCREL((*IF +
                          DEITEM *NE 0))                              /*100879*/
             CPYF       FROMFILE(EXCGUDT3PD) TOFILE(CGUDT3PD) +
                          FROMMBR(&B0MBR) MBROPT(*ADD) INCREL((*IF +
                          DEITEM *NE 0))                              /*100879*/
/* */                                                                 /*083768*/
             GOTO       CMDLBL(LOOP)                                  /*083768*/
/* */
 ENDL:
/* */
/* Update status to Not Active - component finished */
/* */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2090 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2090 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
