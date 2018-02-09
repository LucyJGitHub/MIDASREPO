/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB Set trigger control date area')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication Module                                  */
/*                                                                   */
/*       RPC1318 - Set trigger control data area parameters.         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 02Mar01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&DtaAraLib &JobD &JobQ &Exist &Dmlib)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Sbs)        TYPE(*CHAR) LEN(2)
             DCL        VAR(&Dmlib)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&DtaAraLib)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobD)       TYPE(*CHAR) LEN(20)
             DCL        VAR(&JobQ)       TYPE(*CHAR) LEN(20)
             DCL        VAR(&Exist)      TYPE(*LGL)  LEN(1)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&JobDescr)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobDLib)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobQueue)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobQLib)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Set values within trigger control data area.                     */
/*-------------------------------------------------------------------*/
 
             IF COND(&Exist  = '1') Then(Do)
                CHGDTAARA  DTAARA(&Dmlib/RPTRG) VALUE(&DtaAraLib *CAT +
                                                       &JobD *CAT +
                                                       &JobQ)
              Enddo
             Else       CMD(Do)
             CRTDTAARA  DTAARA(&DMLIB/RPTRG) TYPE(*CHAR) LEN(50) +
                          VALUE(&DTAARALIB *CAT &JOBD *CAT &JOBQ) +
                          TEXT('Midas PB Meridian Trigger Control +
                          Data Area') AUT(*LIBCRTAUT)
             Enddo
 
             GOTO ENDPGM
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1318 - Set Trigger control data area +
                                         - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
