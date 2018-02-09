/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       Y2SNMGC - (Program Name)                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD020016           Date 18Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      XNNNNN  *CREATE    Date DDMmmYY              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD020016 - Moved from zone to global layer.                 */
/*                                                                   */
/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Y2 R2.1.1 Send a message (SNDxxxMSG)')                */
/*********************************************************************/
/*T: YAPPOBJ Send a message SNDxxxMSG */
/*Z: CRTCLPGM LOG(*NO)  */
/*H: SYSTEM     : SYNON/2 SHIPPED SUBROUTINE                                 */
/*H: PROGRAMMER : PV                                                         */
/*H: DATE       : 18/01/88                                                   */
/*       (c) Finastra International Limited 2001                     */
 
/*H:  SYNOPSIS:                                                              */
/*H:  Send a message to the given program message queue.                     */
/*H:  *..................................................................... */
/*H:  2. INTERFACE DETAILS ;                                                 */
/*H:  *..................................................................... */
/*H:  *  Send message to specified program queue.                            */
/*H: C                     CALL 'Y2SNMGC'                  SEND MESSAGE      */
/*H: C                     PARM           ZAPGNM 10        I:PGM Q NAME,*EXT */
/*H: C                     PARM           ZAPGRL  5        I:*SAME,*EXT,*PRV */
/*H: C                     PARM           ZAMSID  7        I:MESSAGE ID      */
/*H: C                     PARM           ZAMSGF 10        I:MESSAGE FILE    */
/*H: C                     PARM           ZAMSDA132        I:MESSAGE DATE    */
/*H: C                     PARM           ZAMSTP  7        I:MESSAGE TYPE    */
/*H:  *..................................................................... */
/********************************************************************/
PGM   (&ZAPGVN &ZAPGRL &ZAMSID &ZAMSGF &ZAMSDA &ZAMSTP)
 
DCL &ZAPGVN   *CHAR 10 /* PGM MSGQ, *EXT      */
DCL &ZAPGRL   *CHAR  5 /* *SAME,*PRV,*EXT     */
DCL &ZAMSID   *CHAR  7 /* MESSAGE ID. XXXNNNN.*/
DCL &ZAMSGF   *CHAR 10 /* MESSAGE FILE        */
DCL &ZAMSDA   *CHAR 132 /* MESSAGE SUBSTITION DATA. */
DCL &ZAMSTP   *CHAR  7 /* MESSAGE TYPE.*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*=================================================================*/
/*H: 1.  DEFAULT CERTAIN MESSAGE PARAMETERS. */
/*/COPY WNCPYSRC,Y2SNMGC001                                          */
         IF (&ZAMSID = ' ') CHGVAR &ZAMSID YYY0101
         IF (&ZAPGVN = ' ') DO
            CHGVAR &ZAPGVN '*'
            CHGVAR &ZAPGRL '*PRV'
         ENDDO
         ELSE DO
            IF (&ZAPGRL = ' ') CHGVAR &ZAPGRL *SAME
         ENDDO
         IF (&ZAMSTP = ' ') CHGVAR &ZAMSTP *DIAG
/*=================================================================*/
/*H: 2.  SEND THE MESSAGE. */
         IF         COND((&ZAPGVN = *EXT) *OR (&ZAPGRL = *EXT)) +
                    THEN(SNDPGMMSG MSGID(&ZAMSID) MSGF(&ZAMSGF) +
                         MSGDTA(&ZAMSDA) TOPGMQ(*EXT) +
                         MSGTYPE(&ZAMSTP))
         ELSE +
           SNDPGMMSG MSGID(&ZAMSID) MSGF(&ZAMSGF) MSGDTA(&ZAMSDA) +
                       TOPGMQ(&ZAPGRL &ZAPGVN) MSGTYPE(&ZAMSTP)
         RMVMSG     CLEAR(*ALL)
/*/COPY WNCPYSRC,Y2SNMGC002                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
