/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Save Savf Receivers to tape')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2458 - Save SAVF Receivers to tape                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CSC002             Date 14Mar96              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CSC002 - Change Save/Restore to two tapes IC Term           */
/*                and Begin of Day                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DEVICE &VOLID)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARFMT) TYPE(*CHAR) LEN(200)
/* */
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SAVE_TYPE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE_FILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DEVICE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VOLID) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
/**/
/* File of journal receiver save file object descriptions */
/**/
             DCLF       FILE(QADSPOBJ)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Check if swicthable feature installed */
/* */
             CHGVAR     VAR(&RETURN) VALUE('       ')
             CHGVAR     VAR(&OPTION) VALUE('*VERIFY')
             CHGVAR     VAR(&SARNBR) VALUE('CSC002')
/* */
             CALL       PGM(AOSARDR0) PARM(&RETURN &OPTION &SARNBR +
                          &SARFMT)
             IF         COND(&RETURN *NE '       ') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('SCC2458 - Save SAVF Receivers to Tape +
                          ') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/**************************************************************/
/*                                                            */
/* S A V E   A L L   J O U R N A L    R E C E I V E R         */
/* S A V E   F I L E S                                        */
/*                                                            */
/**************************************************************/
/* */
/* If Auto Cob and save of recievers FOR ICT is to disk */
/* */
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
             IF         COND((%SST(&CB_AUTO 66 4) *EQ '*YES') *AND +
                             (%SST(&CB_AUTO 31 5) *EQ '*DISK')) +
                        THEN(DO)
/**/
/* Write a list of all journal receivers save files */
/* to SAV_IC_RCV                                    */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&LIB) VALUE(&SYSID *CAT 'DILIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2458MP8                                          */
                                                                      /*S01408*/
/************DSPOBJD****OBJ(&LIB/ICRCV*)*OBJTYPE(*FILE)*+***********************************CSC020*/
/***********************OUTPUT(*OUTFILE)*OUTFILE(QTEMP/SAV_IC_RCV)**************************CSC020*/
             DSPOBJD    OBJ(&LIB/IR*) OBJTYPE(*FILE) +
                        OUTPUT(*OUTFILE) OUTFILE(QTEMP/SAV_IC_RCV)                        /*CSC020*/
             MONMSG     MSGID(CPF2123) EXEC(GOTO CMDLBL(END_LOOP))
/**/
/* Save all journal receiver save files             */
/**/
             OVRDBF     FILE(QADSPOBJ) TOFILE(SAV_IC_RCV)
/**/
/* Define save parameters                        */
/**/
             CHGVAR     VAR(&LIBRARY) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&SAVE_TYPE) VALUE('SAVF')
/************CHGVAR*****VAR(&SAVE_FILE)*VALUE('ICRCVxxx**xxDILIB***')***********************CSC020*/
             CHGVAR     VAR(&SAVE_FILE) VALUE('IRxxxxxxxxxxDILIB   ')                     /*CSC020*/
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)
/* */
/*/COPY WNCPYSRC,SCC2458MP2                                          */
/* */
 START_LOOP: RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END_LOOP))
/**/
             IF         COND(&ODOBAT *EQ 'SAVF') THEN(DO)
/**/
/* Save the database library                     */
/**/
             CHGVAR     VAR(%SST(&SAVE_FILE 1 10)) VALUE(&ODOBNM)
/**/
             CALL       PGM(SCC1767) PARM(&LIBRARY &SAVE_TYPE +
                          &SAVE_FILE &DEVICE &VOLID)
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Job Terminated - Database +
                          Error in SCC1767')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX11)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             ENDDO
             ELSE       CMD(DO)
             SNDPGMMSG  MSG('File' *BCAT &ODOBNM *BCAT 'with +
                          attribute' *BCAT &ODOBAT *BCAT 'found in' +
                          *BCAT &LIB) TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('File' *BCAT &ODOBNM *BCAT 'with +
                          attribute' *BCAT &ODOBAT *BCAT 'found in' +
                          *BCAT &LIB) TOMSGQ(QSYSOPR)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             GOTO       CMDLBL(START_LOOP)
END_LOOP:
/*/COPY WNCPYSRC,SCC2458001                                          */
             ENDDO
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
             SNDPGMMSG  MSG('Program SCC2458 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC2458 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
