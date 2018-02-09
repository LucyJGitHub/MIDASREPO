/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SF Request universal password change')          */
/*********************************************************************/
/*                                                                   */
/*  Midas Security Profile Facility                          */
/*                                                                   */
/*  SFC0050  - CL COMPONENT TO CONTROL SF0050                        */
/*             REQUEST UNIVERSAL PASSWORD CHANGE                     */
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
/*       Prev Amend No. E28090             Date 06Sep91              */
/*                      RT0157             Date 24Jun91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  E28090 - Amend calls to SFC0700 to reflect the rewrite           */
/*           of that program.                                        */
/*  RT0157 - Messages should be sent via new Midas Info Screen.      */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*E28090*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             CHGJOB     SWS(00000000)
 
             CALL       PGM(SF0050)
 
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
/************SNDPGMMSG  MSG('Password Change Facility not used-option+/*RT0157*/
/************             not available') TOPGMQ(*EXT) TOMSGQ(MOPERQ) /*RT0157*/
                SNDPGMMSG  MSG('Password Change Facility +
                             not used - option not available') +
                             TOMSGQ(MOPERQ)                           /*RT0157*/
/***************CALL       PGM(SFC0700) PARM('SFC0050' +
/***************             'PWDCHGNOGO' ' ')             /*RT0157*/ /*E28090*/
                RTVMSG    MSGID(SFM0011) MSGF(MIDASMSG) MSG(&MESSAGE) /*E28090*/
                CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)  /*E28090*/
                RTVMSG    MSGID(SFM0012) MSGF(MIDASMSG) MSG(&MESSAGE) /*E28090*/
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)  /*E28090*/
                RTVMSG    MSGID(SFM0013) MSGF(MIDASMSG) MSG(&MESSAGE) /*E28090*/
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)  /*E28090*/
                CHGDTAARA  DTAARA(MIDASMSG (4 1)) VALUE('1')          /*E28090*/
                CALL       PGM(SFC0700) PARM('SFC0050' 'ENTER' ' ')   /*E28090*/
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
