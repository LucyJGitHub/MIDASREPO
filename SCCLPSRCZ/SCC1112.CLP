/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Save Leo library list information')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                            */
/*                                                                   */
/*       SCC1112 - Save Leo Library List Information.                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10May95              */
/*                      086919             Date 28APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       S01408 - Addition of core hook SC1112MP1                    */
/*       086919 - Processing split from SCC0411 into it's own        */
/*                component.                                         */
/*                                                                   */
/*********************************************************************/
             PGM
 
/***COPY*SCCPYSRC,SCC1112INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SCC1112INT                                          */                   /*CPK024*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(275)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/***COPY*SCCPYSRC,SCC1112MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SCC1112MPS                                          */                   /*CPK024*/
 
/* Find the Leo system prefix from the data area LOPREF */
 
             RTVDTAARA  DTAARA(LOPREF *ALL) RTNVAR(&PREF)
 
/* If either position is blank, this is an error, end the program */
             IF         COND((%SUBSTRING(&PREF 1 1) *EQ ' ') *OR +
                          (%SUBSTRING(&PREF 2 1) *EQ ' ')) THEN(DO)
                SNDPGMMSG  MSG('The Leo System Prefix has not been +
                             correctly entered') TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Retrieve the usrlibl from the job attributes. Put this data in */
/* a data area in the Leo DTALIB.                                 */
 
             CHGVAR     VAR(&DTALIB) VALUE(&PREF *CAT 'DTALIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1112MP1                                          */
                                                                      /*S01408*/
 
             RTVJOBA    USRLIBL(&LIBL)
 
             CHGDTAARA  DTAARA(&DTALIB/MIDLIBL) VALUE(&LIBL)
 
/***COPY*SCCPYSRC,SCC1112MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SCC1112MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination */
 
/***COPY*SCCPYSRC,SCC1112ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SCC1112ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC1112 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/***COPY*SCCPYSRC,SCC1112END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SCC1112END                                          */                   /*CPK024*/
 
             ENDPGM
