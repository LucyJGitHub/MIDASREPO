/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ RTEVENTS Check for Member')                  */
/*********************************************************************/
/*                                                                   */
/*      Midas - Midas/Q Module                                       */
/*                                                                   */
/*      MQ541AC - Checks for a Member in File MQ541XPF               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 193655             Date 26May06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CMQ001             Date 31Oct97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       193655 - Remove hard-coding of library name.                */
/*       CMQ001 - MidasQ rationalisation.                            */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&MQID &DTALIB)
/**/
             DCL        VAR(&MQID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/** Check for Member **/
/*********** CHKOBJ     OBJ(&DTALIB/MQ541XPF) OBJTYPE(*FILE) +
                          MBR(&MQID) AUT(*CHANGE)                     /*193655*/
             CHKOBJ     OBJ(*LIBL/MQ541XPF) OBJTYPE(*FILE) +
                          MBR(&MQID) AUT(*CHANGE)                     /*193655*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
/**/
/** Create The Member **/
/*********** ADDPFM     FILE(&DTALIB/MQ541XPF) MBR(&MQID)             /*193655*/
             ADDPFM     FILE(*LIBL/MQ541XPF) MBR(&MQID)               /*193655*/
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
