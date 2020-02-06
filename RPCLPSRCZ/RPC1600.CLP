/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Additional Journal Entry for Q Action')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1600 -  Additional Journal Entry for 'Q' Action          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG9619            Date 01Feb06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      186611  *CREATE    Date 21Nov00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       186611 - API Repair Queues : Review Delete Operation.       */
/*                                                                   */
/*                To distinguish 'Delete' in Repair Queues between   */
/*                                                                   */
/*                   - Delete by action code 'Q' (Module 'RPB')      */
/*                     (Message Refused by Midas)                    */
/*                and                                                */
/*                   - Delete after Main File updated (Module 'RPR') */
/*                     (Message Accepted by Midas)                   */
/*                                                                   */
/*                Send a User Defined Journal Entry for the Invalid  */
/*                File and ensure Action Code is set to 'D'. So,     */
/*                Front Office system will receive a return message  */
/*                for Invalid File(s) ONLY when Message is refused   */
/*                by Midas.                                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&EntDta &File)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&EntDta)     TYPE(*CHAR) LEN(3000)
             DCL        VAR(&File)       TYPE(*CHAR) LEN(10)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Mem)        TYPE(*CHAR) LEN(50)
                 /* Message text sent to MOPERQ.  */
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128) +
                 /* Message text sent to MRUNQ MOPERQ.  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------*/
/*  Create LDA, if not present.  */
/*-------------------------------*/
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                   CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                                AUT(*EXCLUDE)
             ENDDO
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/**********  SNDJRNE    JRN(ICJRN) TYPE('DL') ENTDTA(&ENTDTA) + */                       /*BUG9619*/
/**********               FILE(&FILE) */                                                 /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('DL') ENTDTA(&ENTDTA) +
                          FILE(&FILE) FORCE(*YES)                                        /*BUG9619*/
 
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1600 - Additional Journal Entry for +
                                 ''Q'' Action - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
