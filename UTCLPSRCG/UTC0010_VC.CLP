/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UT CHGOBJ validity checker')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       UTC0010_VC - Validity checker for CHGOBJ command            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUT008             Date 18Jan11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK018             Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014 *CREATE     Date 23Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT008 - CRTOBJ rewrite.                                    */
/*                Allow change of source member name to an object.   */
/*                Source file, library need not to be specified.     */
/*                Remove the checks for soruce file, lib and member. */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CPK014 - Releaase 4 Packaging                               */
/*              - New Validity checker to prevent CRTOBJ falling over*/
/*                                                                   */
/*********************************************************************/
 
/**********  PGM        PARM(&OBJANDLIB &OBJTYPE &NEWFILE &NEWLIB +                    */ /*CUT008*/
/**********               &SRCLSTCHG)                                                  */ /*CUT008*/
             PGM        PARM(&OBJANDLIB &OBJTYPE &NEWFILE &NEWLIB +
                          &NEWMBR &SRCLSTCHG)                                             /*CUT008*/
 
             DCL        VAR(&OBJANDLIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&NEWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWMBR) TYPE(*CHAR) LEN(10)                                  /*CUT008*/
             DCL        VAR(&SRCLSTCHG) TYPE(*CHAR) LEN(13)
 
             DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&DATE_ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
 
             DCL        VAR(&CENTURY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&YEAR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MONTH) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DAY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&YEARN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&DIVYEAR) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DIVYEARN) TYPE(*DEC) LEN(5 2)
             DCL        VAR(&REM) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Extract variables from parameter                               */
             CHGVAR     VAR(&OBJ) VALUE(%SST(&OBJANDLIB 1 10))
             CHGVAR     VAR(&OBJLIB) VALUE(%SST(&OBJANDLIB 11 10))
 
/* Check whether object type is valid                             */
             CHKOBJ     OBJ(DUMMYOBJ) OBJTYPE(&OBJTYPE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810 CPF9820) +
                          EXEC(RCVMSG MSGQ(*PGMQ) RMV(*YES))
             MONMSG     MSGID(CPF0001) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Object type ' *CAT &OBJTYPE +
                             *TCAT ' is not a valid object type') +
                             MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
             ENDDO
 
/* Check object exists and user has sufficient authority          */
             IF         COND(&ERROR *NE 'Y') THEN(DO)
                CHKOBJ     OBJ(&OBJLIB/&OBJ) OBJTYPE(&OBJTYPE) AUT(*ALL)
                   MONMSG     MSGID(CPF0001 CPF9801 CPF9802 CPF9810) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000' +
                             *CAT &OBJ *TCAT ' does not exist or +
                             you have insufficient authority') +
                             MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                ENDDO
             ENDDO
 
/*****Check*new*source*library*exists**********************************/ /*            */ /*CUT008*/
/**********  CHKOBJ     OBJ(&NEWLIB) OBJTYPE(*LIB)                                     */ /*CUT008*/
/**********  MONMSG     MSGID(CPF0001 CPF9801) EXEC(DO)                                */ /*CUT008*/
/**********     SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000New +              */ /*CUT008*/
/**********               Source Library ' *CAT &NEWLIB *TCAT ' not +                  */ /*CUT008*/
/**********               found.') MSGTYPE(*DIAG)                                      */ /*CUT008*/
/**********     CHGVAR     VAR(&ERROR) VALUE('Y')                                      */ /*CUT008*/
/**********  ENDDO                                                                     */ /*CUT008*/
 
/*****Check*new*source*file*exists*************************************/ /*            */ /*CUT008*/
/**********  CHKOBJ     OBJ(&NEWLIB/&NEWFILE) OBJTYPE(*FILE)                           */ /*CUT008*/
/**********  MONMSG     MSGID(CPF0001 CPF9801 CPF9810) EXEC(DO)                        */ /*CUT008*/
/**********     SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000New +              */ /*CUT008*/
/**********               source file ' *CAT &NEWFILE *TCAT ' not +                    */ /*CUT008*/
/**********               found.') MSGTYPE(*DIAG)                                      */ /*CUT008*/
/**********     CHGVAR     VAR(&ERROR) VALUE('Y')                                      */ /*CUT008*/
/**********  ENDDO                                                                     */ /*CUT008*/
 
/* Check validity of Source Last Changed Date                     */
             IF         COND(&SRCLSTCHG *NE ' ') THEN(DO)
 
/* Break down date fields.                                        */
                CHGVAR     VAR(&CENTURY) VALUE(%SST(&SRCLSTCHG 1 1))
                CHGVAR     VAR(&YEAR) VALUE(%SST(&SRCLSTCHG 2 2))
                CHGVAR     VAR(&MONTH) VALUE(%SST(&SRCLSTCHG 4 2))
                CHGVAR     VAR(&DAY) VALUE(%SST(&SRCLSTCHG 6 2))
 
                IF         COND(&CENTURY *NE '1' *AND &CENTURY *NE '0') +
                          THEN(DO)
                   CHGVAR     VAR(&DATE_ERROR) VALUE('Y')
                   GOTO       CMDLBL(DATECHK)
                ENDDO
                IF         COND(&YEAR *LT '00' *OR &YEAR *GT '99') +
                             THEN(DO)
                   CHGVAR     VAR(&DATE_ERROR) VALUE('Y')
                   GOTO       CMDLBL(DATECHK)
                ENDDO
                IF         COND(&MONTH *LT '01' *OR &MONTH *GT '12') +
                             THEN(DO)
                   CHGVAR     VAR(&DATE_ERROR) VALUE('Y')
                   GOTO       CMDLBL(DATECHK)
                ENDDO
                IF         COND(&DAY *LT '01' *OR &DAY *GT '31') +
                             THEN(DO)
                   CHGVAR     VAR(&DATE_ERROR) VALUE('Y')
                   GOTO       CMDLBL(DATECHK)
                ENDDO
                IF         COND(&MONTH *EQ '02' *OR &MONTH *EQ '04' *OR +
                             &MONTH *EQ '06' *OR &MONTH *EQ '09' *OR +
                             &MONTH *EQ '11') THEN(DO)
                   IF         COND(&DAY *EQ '31') THEN(DO)
                      CHGVAR     VAR(&DATE_ERROR) VALUE('Y')
                      GOTO       CMDLBL(DATECHK)
                   ENDDO
                ENDDO
                IF         COND(&MONTH *EQ '02') THEN(DO)
                   IF         COND(&DAY *EQ '30') THEN(DO)
                      CHGVAR     VAR(&DATE_ERROR) VALUE('Y')
                      GOTO       CMDLBL(DATECHK)
                   ENDDO
                   IF         COND(&DAY *EQ '29' *AND &YEAR *NE '00') +
                             THEN(DO)
                      CHGVAR     VAR(&YEARN) VALUE(&YEAR)
                      CHGVAR     VAR(&DIVYEARN) VALUE(&YEARN / 4)
                      CHGVAR     VAR(&DIVYEAR) VALUE(&DIVYEARN)
                      CHGVAR     VAR(&REM) VALUE(%SST(&DIVYEAR 4 2))
                      IF         COND(&REM *NE '00') THEN(DO)
                         CHGVAR     VAR(&DATE_ERROR) VALUE('Y')
                         GOTO       CMDLBL(DATECHK)
                      ENDDO
                   ENDDO
                ENDDO
             ENDDO
 
DATECHK:
             IF         COND(&DATE_ERROR *EQ 'Y') THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Date is not valid.') +
                             MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
             ENDDO
 
/*    Send message to cause CPF to pass earlier messages back       */
            IF  COND(&ERROR *EQ 'Y') THEN(+
            SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
