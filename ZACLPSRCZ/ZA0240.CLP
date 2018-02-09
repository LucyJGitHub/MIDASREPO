/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Add message to pgm subfile message queue')      */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Common processing                          */
/*                                                                   */
/*          ZA0240 - SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 248597             Date 22Jun07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      240474             Date 21Aug06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      BH3158             Date 20Aug91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*      248597 - Try checking msgid in XX message file.              */
/*               and correct code for Fix 240474                     */
/*      240474 - Try checking msgid in FT message file.              */
/*      E25959 - MONITOR FOR AN ERROR IN SENDING THE MESSAGE         */
/*               TO AVOID PROGRAM CRASH IN PROGRAM USING ZA0240      */
/*                                                                   */
/*********************************************************************/
/**/
PGM        PARM(&@MSGID)
             DCL        VAR(&@MSGID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*/COPY WNCPYSRC,ZA0240001                                           */
             SNDPGMMSG  MSGID(&@MSGID) MSGF(DRSMM)
/****        MONMSG     MSGID(CPF2469) EXEC(SNDPGMMSG  MSGID(&@MSGID) +                   /*248597*/
/****                     MSGF(FTUSRMSG))                                      /*240474*/ /*248597*/
/****        MONMSG     MSGID(CPF2469) EXEC(SNDPGMMSG MSGID(CPF9898) +                    /*248597*/
/****                     MSGF(QCPFMSG) MSGDTA('Unable to send +                          /*248597*/
/****                     message' *BCAT &@MSGID))                             /*240474*/ /*248597*/
             MONMSG     MSGID(CPF2469) EXEC(DO)                                           /*248597*/
                   SNDPGMMSG  MSGID(&@MSGID) MSGF(FTUSRMSG)                               /*248597*/
                   MONMSG     MSGID(CPF2469) EXEC(DO)                                     /*248597*/
                         SNDPGMMSG  MSGID(&@MSGID) MSGF(XXUSRMSG)                         /*248597*/
                         MONMSG     MSGID(CPF2469) EXEC(SNDPGMMSG MSGID(CPF9898) +
                          MSGF(QCPFMSG) MSGDTA('UNABLE TO SEND +
                          MESSAGE' *BCAT &@MSGID))                                        /*248597*/
                   ENDDO                                                                  /*248597*/
             ENDDO                                                                        /*248597*/
                                                                                          /*248597*/
/*/COPY WNCPYSRC,ZA0240003                                           */
/**********  MONMSG     MSGID(CPF2469) EXEC(SNDPGMMSG MSGID(CPF9898) +
/**********               MSGF(QCPFMSG) MSGDTA('Unable to send +
/**********               message' *BCAT &@MSGID))                    /*E25959*/          /*240474*/
                                                                                          /*240474*/
/*/COPY WNCPYSRC,ZA0240002                                           */
 
GOTO ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM: ENDPGM
