/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       mmCnnnn - (Program Name)                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      XNNNNN  *CREATE    Date DDMmmYY              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes                          */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Y2 R2.1.1 Send a message')                            */
/*********************************************************************/
/*T: YAPPOBJ Send a message - PRE-8.3 VERSION         */
/*Z: CRTCLPGM LOG(*NO)  */
/*H: SYSTEM     : SYNON/2 SHIPPED SUBROUTINE                                 */
/*H: PROGRAMMER : P.WILSON                                                   */
/*H: DATE       : 1984                                                       */
/*       (c) Finastra International Limited 2001                     */
/*M: 25.02.87 JPL - Direct message to *EXT if either pgmq or pgmrel is *EXT  */
 
/*H:  SYNOPSIS:                                                              */
/*H:  Send a message to the given program message queue.                     */
/*H:  The message file from which the message is to be retrieved is          */
/*H:  determined by examining the message prefix and taking an               */
/*H:  intellegent guess.                                                     */
/*H:  *..................................................................... */
/*H:  2. INTERFACE DETAILS ;                                                 */
/*H:  *..................................................................... */
/*H:  *  Send message to specified program queue.                            */
/*H: C                     CALL 'Y2SNMSC'                  SEND MESSAGE      */
/*H: C                     PARM           ZAPGNM 10        I:PGM Q NAME,*EXT */
/*H: C                     PARM           ZAPGRL  5        I:*SAME,*EXT,*PRV */
/*H: C                     PARM           ZAMSID  7        I:MESSAGE ID      */
/*H: C                     PARM           ZAMSDA132        I:MESSAGE DATE    */
/*H: C                     PARM           ZAMSTP  7        I:MESSAGE TYPE    */
/*H:  *..................................................................... */
/*********************************************************************/
PGM   (&ZAPGVN &ZAPGRL &ZAMSID &ZAMSDA &ZAMSTP)
 
DCL &ZAPGVN   *CHAR 10 /* PGM MSGQ, *EXT      */
DCL &ZAPGRL   *CHAR  5 /* *SAME,*PRV,*EXT     */
DCL &ZAMSID   *CHAR  7 /* MESSAGE ID. XXXNNNN.*/
DCL &MSGPFX   *CHAR  3 /* XXX OF MESSAGE ID.*/
DCL &ZAMSDA   *CHAR 132 /* MESSAGE SUBSTITION DATA. */
DCL &ZAMSTP   *CHAR  7 /* MESSAGE TYPE.*/
DCL &MSGF     *CHAR 10 /* MESSAGE FILE.*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*H: 2.1 DEFAULT CERTAIN MESSAGE PARAMETERS. */
         IF (&ZAMSID = ' ') CHGVAR &ZAMSID YYY0101
         IF (&ZAPGVN = ' ') DO
            CHGVAR &ZAPGVN '*'
            CHGVAR &ZAPGRL '*PRV'
         ENDDO
         ELSE DO
            IF (&ZAPGRL = ' ') CHGVAR &ZAPGRL *SAME
         ENDDO
         IF (&ZAMSTP = ' ') CHGVAR &ZAMSTP *DIAG
/*H: 2.2 DETERMINE MESSAGE FILE.*/
         CHGVAR &MSGPFX %SST(&ZAMSID 1 3)
              IF (%SST(&ZAMSID 1 2) = CP)  CHGVAR &MSGF QCPFMSG
         ELSE IF (&MSGPFX           = Y2U) CHGVAR &MSGF Y2USRMSG
         ELSE IF (%SST(&ZAMSID 1 2) = Y2)  CHGVAR &MSGF Y2MSG
         ELSE IF (%SST(&ZAMSID 1 1) = Y)   CHGVAR &MSGF YYYYMSG
         ELSE IF (%SST(&ZAMSID 1 1) = U)   CHGVAR &MSGF QUSRMSG
         ELSE IF (&MSGPFX           = RPG) CHGVAR &MSGF QRPGMSGE
         ELSE IF (&MSGPFX           = CBL) CHGVAR &MSGF QCBLMSGE
         ELSE IF (&MSGPFX           = PLI) CHGVAR &MSGF QPLIMSGE
         ELSE IF (&MSGPFX           = QTU) CHGVAR &MSGF QTXTMSG
         ELSE IF (&MSGPFX           = EDT) CHGVAR &MSGF QEDTMSG
/********** ELSE CHGVAR &MSGF (%SST(&ZAMSID 1 2)**< USRMSG)                        */  /*BG18886*/
         ELSE CHGVAR &MSGF (%SST(&ZAMSID 1 2) *TCAT USRMSG)                            /*BG18886*/
         IF ( (&ZAPGVN = *EXT) *OR (&ZAPGRL = *EXT) ) +
           SNDPGMMSG MSGID(&ZAMSID) MSGF(&MSGF) MSGDTA(&ZAMSDA) +
                       TOPGMQ(*EXT) MSGTYPE(&ZAMSTP)
         ELSE +
           SNDPGMMSG MSGID(&ZAMSID) MSGF(&MSGF) MSGDTA(&ZAMSDA) +
                       TOPGMQ(&ZAPGRL &ZAPGVN) MSGTYPE(&ZAMSTP)
         RMVMSG     CLEAR(*ALL)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
