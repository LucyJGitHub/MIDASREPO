/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB Retrive job description and change libl')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication Module                                  */
/*                                                                   */
/*       RPC1319 - Setup Library list for the replication            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 16Mar01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes                          */
/*       CSC017 - Change to 250 library list.                        */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&Return &Action)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Return)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&Action)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&JobD)       TYPE(*CHAR) LEN(10)
/************DCL        VAR(&InlLibl)    TYPE(*CHAR) LEN(275)                          */ /*CSC017*/
/************DCL        VAR(&Cmd)        TYPE(*CHAR) LEN(289)                          */ /*CSC017*/
             DCL        VAR(&InlLibl)    TYPE(*CHAR) LEN(2750)                            /*CSC017*/
             DCL        VAR(&Cmd)        TYPE(*CHAR) LEN(2764)                            /*CSC017*/
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*----------------------------------*/
/*  Setup Replication library list  */
/*----------------------------------*/
             IF         COND(&Action = 'SETUP') THEN(DO)
 
                  CHKOBJ     OBJ(RPTRG) OBJTYPE(*DTAARA)
                  MONMSG     MSGID(CPF9801) EXEC(DO)
                     CHGVAR     VAR(&Jobd) VALUE('TIJOBD')
                  ENDDO
 
                  IF    COND(&Jobd = ' ') THEN(DO)
                     RTVDTAARA  DTAARA(RPTRG (11 10)) RTNVAR(&Jobd)
                     IF    COND(&Jobd = ' ') THEN(DO)
                        CHGVAR     VAR(&Jobd) VALUE('TIJOBD')
                     ENDDO
                  ENDDO
             ENDDO
 
/*----------------------------*/
/*  Restor library List list  */
/*----------------------------*/
             IF         COND(&Action = 'RESTORE') THEN(DO)
                  CHGVAR     VAR(&Jobd) VALUE('MIDASIC')
             ENDDO
 
/**********  IF         COND(&Action *= 'SETUP' *AND &Action *= +
                          'RESTORE') THEN(DO)                                         */ /*BG18886*/
             IF         COND(&Action *NE 'SETUP' *AND &Action *NE +
                          'RESTORE') THEN(DO)                                            /*BG18886*/
                  GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*---------------------------*/
/*  Setup library List list  */
/*---------------------------*/
             RTVJOBD    JOBD(&Jobd) INLLIBL(&InlLibl)
 
             CHGVAR     VAR(&Cmd) VALUE('CHGLIBL LIBL(' *CAT +
                             &InlLibl *CAT ')')
 
/************CALL       PGM(QCMDEXC) PARM(&Cmd 289)                                    */ /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&Cmd 2764)                                      /*CSC017*/
 
             GOTO ENDPGM
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Return) VALUE('*ERROR*')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1319 - Setup library list with job description +
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
