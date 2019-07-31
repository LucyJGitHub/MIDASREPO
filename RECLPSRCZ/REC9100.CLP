/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE VAT and Taux D'Usure maintenance control')   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                                   */
/*                                                                   */
/*       REC9100 - VAT Maintenance control program                   */
/*                 Check VAT and Taux D'Usure                        */
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
/*                      111690             Date 27Feb97              */
/*                      088200 *CREATE*    Date 19Jun95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       111690 - wrong message ID used                              */
/*       088200 - After user selects VAT Maintenance, this program   */
/*                checks TABTBRE for status of VAT and Taux D'Usure. */
/*                If either is ON, the maintenance program is called.*/
/*                (passed as a parameter from SPF).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROGRAM)
 
/***COPY*SDCPYSRC,REC9100INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,REC9100INT                                          */                   /*CPK024*/
 
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(TABTBRE)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*SDCPYSRC,REC9100MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,REC9100MPS                                          */                   /*CPK024*/
 
/* Check for VAT and Taux D'Usure in PF/TABTBRE         */
/* At R10.6 Taux D'Usure is not a core function, but most (all?) of */
/*  the code, including the flags, are in core.                     */
/*  Thus the message that should be sent if this function is not    */
/*  available depends upon which features are available (as opposed */
/*  to swicted on) in teh system.                                   */
 
/* If either feature is switched on call the program.               */
/* If neither feature is switched on call the program.              */
/*  - if only VAT is available send that message                    */
/*  - if both are available send that message                       */
 
             RCVF       RCDFMT(TABTBREF)
 
             IF         COND(&VATP *EQ 'Y' *OR &TEGP *EQ 'Y') +
                          THEN(CALL PGM(&PROGRAM))
             ELSE       CMD(DO)
 
                IF         COND(&IVATP *EQ 'Y' *AND &ITEGP *NE 'Y') +
                             THEN(DO)
                   RTVMSG     MSGID(REM0001) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(REM0002) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
                ENDDO
 
                IF         COND(&IVATP *EQ 'Y' *AND &ITEGP *EQ 'Y') +
                             THEN(DO)
                   RTVMSG     MSGID(REM0001) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(REM0003) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(REM0004) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (451 50)) VALUE(&MESSAGE)
                ENDDO
 
                CALL       PGM(SCC0010) PARM('REC9100' 'ENTER' &NOREPLY)
 
             ENDDO
 
/***COPY*SDCPYSRC,REC9100MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,REC9100MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*SDCPYSRC,REC9100ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,REC9100ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
 
/**********  RTVMSG     MSGID(SCC0033) MSGF(GBMIDASMSG) MSG(&MESSAGE)   111690*/
             RTVMSG     MSGID(SCM0033) MSGF(GBMIDASMSG) MSG(&MESSAGE) /*111690*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('REC9100' 'ENTER' &NOREPLY)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/***COPY*SDCPYSRC,REC9100END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,REC9100END                                          */                   /*CPK024*/
 
             ENDPGM
