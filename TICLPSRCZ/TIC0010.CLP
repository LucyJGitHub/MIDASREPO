/*********************************************************************/
/*S*D****CLPBASEBND***************************************************/                 /*MD029775*/
/*STD    CLPBASE                                                     */                 /*MD030956*/
/*EXI    TEXT('Midas TI End of day synchronisation RESET')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0010 - End of Day Synchronisation - RESET                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD030956           Date 09Oct14              */
/*                      MD029775           Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CTI003             Date 13Sep00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTI001  *CREATE    Date 05AUG97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD030956 - Additional changes to BFM-TI enhancement.        */
/*                  Reinstated for future use in case of downgrade.  */
/*       MD029775 - TI/Midas EOD sync will no longer be used by TI   */
/*                  Plus                                             */
/*       CTI003 - Midas/TI Interface CoB                             */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
             PGM
 
/************DCL        VAR(&VALUE) TYPE(*CHAR) LEN(10)                                */ /*CTI003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&MSG) VALUE('TIC0010 - End of Day +
                          Midas/TI Synchronisation')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
 
/************CHGVAR     VAR(&VALUE) VALUE('NNNNNNNNNY')                                */ /*CTI003*/
/************CHGDTAARA  DTAARA(TIDTA (1 10)) VALUE(&VALUE)                             */ /*CTI003*/
 
             CHGDTAARA  DTAARA(TIDTA (51 20)) +
                          VALUE('PPPPPPPPPPPPPPPPPPPP')                                   /*CTI003*/
/*/COPY WNCPYSRC,TIC0010001                                          */
                                                                                          /*CTI003*/
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
/* Abnormal termination  */
             CHGVAR     VAR(&MSG) VALUE('TIC0010 - End of Day +
                          Midas/TI Synchronisation terminated +
                          abnormally')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
