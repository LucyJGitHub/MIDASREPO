/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS  Selection of Trace Facility BSC3270')       */
/********************************************************************/
/*                                                                  */
/*     Midas S.W.I.F.T. DIRECT LINK                         */
/*                                                                  */
/*     MSC4050 - FOR SELECTION AND CANCELATION OF TRACE MODE        */
/*               COMMUNICATION PROGRAMS FOR THE 3270 PROTOCOL       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01314           DATE 25APR91                 */
/*     PREV AMEND NO. S01250           DATE 29JAN90                 */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*     S01314 - CHANGES MADE DURING PTF INCORPORATION               */
/*            - ADD COPYRIGHT STATEMENT AND MOVE END LABEL TO       */
/*              ENSURE THAT THE NEW CHGVAR COMMAND IS EXECUTED.     */
/*     S01250 - TRACE MODE FOR 3270 PROTOCOL.                       */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPT)
 
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(51)
             DCL        VAR(&TRACF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                  */
/* Retrive status of Trace Mode and Communications Link from        */
/*         positions 21 and 23 from MSSTAT                          */
/*                                                                  */
 
             RTVDTAARA  DTAARA(MSSTAT (1 51)) RTNVAR(&MSSTAT)
                        CHGVAR   VAR(&TRACF) VALUE(%SST(&MSSTAT 21 1))
                        CHGVAR   VAR(&CPA) VALUE(%SST(&MSSTAT 23 1))
 
/*                                                                  */
/*  If Communications Link active send msg and end program          */
/*                                                                  */
             IF         COND(&CPA *EQ 'Y') THEN(+
                        DO)
                        SNDPGMMSG  MSG('Communication link active, +
                        must be terminated before selecting option +
                        again ') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(END)
                        ENDDO
 
/*                                                                  */
/*  If we wish to enter Trace Mode; check whether or not we are     */
/*        already in TRace Mode.                                    */
/*                                                                  */
             IF         COND(&OPT = 'E') THEN(+
                        DO)
                        IF  COND(&TRACF *NE 'T') +
                            THEN(CHGDTAARA DTAARA(MSSTAT (21 1)) +
                            VALUE('T'))
                        ELSE  CMD(SNDPGMMSG MSG('Communication +
                              programs already set to Trace Mode') +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ))
                        ENDDO
 
/*                                                                  */
/*  If we wish to exit from Trace Mode; check whether or not we     */
/*        are indeed in Trace Mode .                                 */
/*                                                                  */
             IF         COND(&OPT *EQ 'X') THEN(+
                        DO)
                        IF  COND(&TRACF *NE 'T') THEN(SNDPGMMSG +
                            MSG('Communication link is not in Trace +
                            Mode.') TOPGMQ(*EXT) TOMSGQ(MOPERQ))
                        ELSE +
                        CMD(CHGDTAARA DTAARA(MSSTAT (21 1)) VALUE(' '))
                        ENDDO
/**/                                                                  /*S01314*/
/*   SET UP COPYRIGHT  */                                             /*S01314*/
/**/                                                                  /*S01314*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*END:        ENDPGM **/                                              /*S01314*/
             ENDPGM                                                   /*S01314*/
