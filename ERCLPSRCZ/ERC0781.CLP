/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS ABS ER - CAD report')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting                                  */
/*                                                                   */
/*       ERC0781 - CAD report                                        */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX012             Date 15Dec98              */
/*                      ULX004             Date 22APR97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX012 - Guarantees and Collateral Management enhancements  */
/*                Recompile over changed file ERLUICPD               */
/*       ULX004 - Capital Adequacy                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BJMRDT &BJURPT)
 
             DCL        VAR(&BJMRDT) TYPE(*CHAR) LEN(7) /* MIDAS +
                          report date */
             DCL        VAR(&BJURPT) TYPE(*CHAR) LEN(53) /* Title */
 
             DCL        VAR(&ERCAD) TYPE(*CHAR) LEN(10) +
                          VALUE('ERxx81')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/**********  DCLF       FILE(ERLUICPD) RCDFMT(ERLUICD0)                   */              /*CER001*/
             DCLF       FILE(ERLICXPD) RCDFMT(ERLUICD0)                                   /*CER001*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Execute CAD report corresponding to each country            */
 
 REPTLOOP:   RCVF       RCDFMT(ERLUICD0)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             IF         COND(&VPIM14 *NE 'Y') THEN(GOTO +
                          CMDLBL(REPTLOOP))
 
             CHGVAR     VAR(%SST(&ERCAD 3 2)) VALUE(&VPICCD)
 
/**********  SNDPGMMSG  MSG(&ERCAD *BCAT '- CAD AUDIT LIST') +
                          TOMSGQ(CADMSGQ) MSGTYPE(*INFO)                  */              /*CER001*/
             SNDPGMMSG  MSG(&ERCAD *BCAT '- CAD AUDIT LIST') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)                                   /*CER001*/
 
             CALL       PGM(&ERCAD) PARM(&BJMRDT &BJURPT)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
/**********  SNDPGMMSG  MSGID(DBM0004) MSGF(ERUSRMSG) MSGDTA(&ERCAD +
                          *CAT '001') TOMSGQ(CADMSGQ)                     */              /*CER001*/
             SNDPGMMSG  MSGID(DBM0004) MSGF(STUSRMSG) MSGDTA(&ERCAD +
                          *CAT '001') TOMSGQ(MOPERQ)                                      /*CER001*/
/**********  SNDPGMMSG  MSG('CAD Audit List program ' *CAT &ERCAD +
                          *CAT ' for ' *CAT &VPICCD *CAT ' +
                          failed, and will have to be restarted +
                          manually. ') TOMSGQ(CADMSGQ)                    */              /*CER001*/
             SNDPGMMSG  MSG('CAD Audit List program ' *CAT &ERCAD +
                          *CAT ' for ' *CAT &VPICCD *CAT ' +
                          failed, and will have to be restarted +
                          manually. ') TOMSGQ(MOPERQ)                                     /*CER001*/
             ENDDO
 
             GOTO       CMDLBL(REPTLOOP)
 
 ABNOR:
 
/*********   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERC0781 ended abnormally - see job log') +
                          TOMSGQ(CADMSGQ)                                 */              /*CER001*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERC0781 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)                                                  /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
 
             ENDPGM
