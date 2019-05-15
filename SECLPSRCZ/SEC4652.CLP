/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Statement Production - SESTPRL2 ract file')  */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Securities Trading Module                        */
/*                                                                   */
/*       SEC4652  - Midas SE Statement Production - Clear            */
/*                  extract files                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP005             Date 27Aug10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSE040  *CREATE    Date 10Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP005 - Change processing of temporary files for IASP      */
/*       CSE040 - Securities Statement Processing                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SEC4652INT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SEC4652MPS                                          */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
 
/* Midas SE Holding - Financial Instruments                          */
 
             CLRPFM     FILE(SEHFINPD)
 
/* Midas SE Holding - Sub-balance                                    */
 
             CLRPFM     FILE(SEHSBLPD)
 
/* Midas SE Statement - Driver file                                  */
 
             CLRPFM     FILE(SESDRVPD)
 
/* Midas SE Statement - General Information                          */
 
             CLRPFM     FILE(SESGENPD)
 
/* Midas SE Transaction - Financial Instruments                      */
 
             CLRPFM     FILE(SETFINPD)
 
/* Midas SE Transaction - Transaction Indicator                      */
 
             CLRPFM     FILE(SETINDPD)
 
/* Midas SE Transaction - Transaction Party                          */
 
             CLRPFM     FILE(SETPRTPD)
 
/* Midas SE Transaction - Transaction Details                        */
 
             CLRPFM     FILE(SETTRAPD)
 
/* Midas SE MT535/536/537 Data send to MMM                           */
 
             CLRPFM     FILE(SES2MMPD)
 
/* Midas SE Statement Production - XML data - Audit                  */
 
             CLRPFM     FILE(XSEUXMLPD)
 
/* Delete Temporary journal                                          */
 
/*JRN1:****  CHKOBJ     OBJ(&JLIB/SEC4651JRN) OBJTYPE(*JRN)                            */ /*CUP005*/
/**********  MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(JRN2))                         */ /*CUP005*/
 
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/SEC4651JRN)                               */ /*CUP005*/
 
/**********  DLTJRN     JRN(&JLIB/SEC4651JRN)                                          */ /*CUP005*/
 
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CUP005*/
 
/**********  DLTJRNRCV  JRNRCV(&JLIB/SEC4651RCV)                                       */ /*CUP005*/
 
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CUP005*/
 
/*JRN2:****  CHKOBJ     OBJ(&JLIB/SEC4664JRN) OBJTYPE(*JRN)                            */ /*CUP005*/
/**********  MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(END))                          */ /*CUP005*/
 
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/SEC4664JRN)                               */ /*CUP005*/
 
/**********  DLTJRN     JRN(&JLIB/SEC4664JRN)                                          */ /*CUP005*/
 
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CUP005*/
 
/**********  DLTJRNRCV  JRNRCV(&JLIB/SEC4664RCV)                                       */ /*CUP005*/
 
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CUP005*/
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
/*/COPY WNCPYSRC,SEC4652ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SEC4652 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SEC4652END                                          */
 
             ENDPGM
