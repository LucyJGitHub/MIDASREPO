/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Process incoming telexes (TK2000V1.0)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas Testkey Interface Module                      */
/*                                                                   */
/*       MTC3031 - Process Incoming Telexes for Windows Testkey      */
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
/*       Prev Amend No. CTK001  *CREATE    Date 03Apr99              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CTK001 - Testkey module conversion from DOS to WINDOWS      */
/*                95/NT (Testkey II).                                */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
/** Declare program variables */
 
             DCL   VAR(&FLDR)    TYPE(*CHAR)  LEN(8)
             DCL   VAR(&NAME)    TYPE(*CHAR)  LEN(10)
             DCL   VAR(&USID)    TYPE(*CHAR)  LEN(10)
             DCL   VAR(&X)       TYPE(*DEC)   LEN(2 0) VALUE(1)
             DCL   VAR(&Y)       TYPE(*DEC)   LEN(1 0) VALUE(0)
             DCL   VAR(&Z)       TYPE(*CHAR)  LEN(1) VALUE('1')
             DCL   VAR(&SYSPRF)  TYPE(*CHAR)  LEN(2)
             DCL   VAR(&LIB)     TYPE(*CHAR)  LEN(10)
             DCL   VAR(&N#ZTK)   TYPE(*CHAR)  LEN(100)
             DCL   VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
 
/** Declare error handling variables */
 
             DCL   VAR(&JOBTYPE) TYPE(*CHAR)  LEN(1)
             DCL   VAR(&MEM)     TYPE(*CHAR)  LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/** Place library QTEMP on top of the library list */
 
             RMVLIBLE   LIB(QTEMP)
             MONMSG     MSGID(CPF0000)
 
             ADDLIBLE   LIB(QTEMP) POSITION(*FIRST)
 
/** Allocate data area N#ZTK for SHARE READ, if the data area is     */
/** unavailable, send an error message to the workstation and        */
/** terminate processing.                                            */
 
             ALCOBJ     OBJ((N#ZTK *DTAARA *SHRRD))
 
             MONMSG     MSGID(CPF1002) EXEC(DO)
                SNDPGMMSG  MSG('Unable to allocate data area N#ZTK. +
                          Press Enter.') TOPGMQ(*EXT)
                GOTO CMDLBL(END)
             ENDDO
 
/** Retrieve user name for this interactive session and the Midas    */
/** system prefix                                                    */
 
             RTVJOBA    USER(&NAME)
             RTVDTAARA  SDSTAT RTNVAR(&SDSTAT)
             CHGVAR     VAR(&SYSPRF) VALUE(%SUBSTRING(&SDSTAT 6 2))
 
/** Set up Midas database library                                    */
 
             CHGVAR    &LIB  VALUE(&SYSPRF *CAT 'DMLIB')
 
/* Search the data area N#ZTK to check if the requesting user is     */
/* a valid Testkey user.                                             */
 
             RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)
 LOOP:       CHGVAR     VAR(&USID) VALUE(%SUBSTRING(&N#ZTK &X 10))
 
                IF COND(&NAME *EQ &USID) THEN(DO)
                   CHGVAR VAR(&FLDR) VALUE('TFLDR' *CAT &SYSPRF +
                                            *CAT &Z)
                   GOTO COPY
                ENDDO
 
                IF  COND(&Y *EQ 9) THEN(GOTO CMDLBL(ERR))
 
                CHGVAR     VAR(&Y) VALUE(&Y + 1)
                CHGVAR     VAR(&X) VALUE(&X + 10)
                GOTO LOOP
 
/** Before creation of Verified Incoming Telexes file PF/TKINPF,   */
/** check first if TKDEREF.REF exists (ie a new batch of incoming  */
/** message is available for processing).                          */
 
COPY:        CHKDLO     DLO(TKDEREF.REF) FLR(&FLDR)
 
/** Terminate processing if no incoming telexes to be processed.   */
 
             MONMSG     MSGID(CPF8A82) EXEC(DO)
             SNDPGMMSG  MSG('No Verified Incoming Telex to be +
                          processed. Press Enter to continue.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
/** If TKDEREF.REF exists in folder, check if PF/TKINPF can be     */
/** found in QTEMP. Otherwise, create the file.                    */
 
             CHKOBJ     OBJ(QTEMP/TKINPF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(TKINPF) +
                          FROMLIB(&LIB) OBJTYPE(*FILE) TOLIB(QTEMP))
 
/** Copy data from TKDEREF.REF to PF/TKINPF for Verified Incoming  */
/** telex message processing by PGM/MT3030                         */
 
             CPYFRMPCD  FROMFLR(&FLDR) TOFILE(QTEMP/TKINPF) +
                          FROMDOC(TKDEREF.REF)
             MONMSG     MSGID(IWS1611)
/**/
             DLCOBJ     OBJ((N#ZTK *DTAARA *SHRRD))
 
/* Call program to process incoming testkey data which updates  */
/* ORION file N#IH (item title field via LF/N$I1)               */
 
             CALL       PGM(MT3030)
/*                                                                   */
 
             IF       COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             DLTDLO DLO(TKDEREF.REF) FLR(&FLDR)
             MONMSG MSGID(CPF0000 RPG0000 MCH0000 IWS0000)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination - interactive job */
 
             IF COND(&JOBTYPE = '1') THEN(DO)
                CHGVAR VAR(&MEM) VALUE('The job has terminated +
                          abnormally - see job log')
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
                CALL       PGM(SCC0010) PARM('MTC3031' 'ENTER' ' ')
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Display error message for unauthorised access to Testkey */
 
 ERR:        SNDPGMMSG  MSG('Not authorised to Testkey processing. +
                          Press Enter to continue.') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
