/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Set On  2 O'Clock flag')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Banking                                      */
/*                                                                   */
/*       REC2003 - Set On 2'O Clock flag                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE023  *CREATE    Date 29Jul05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CRE023 - 2 O'clock Flag Upgrade to MidasPlus (Recompile)    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
 
             SNDPGMMSG  MSG('Holding Outward Clearing Cheques') +
                        TOMSGQ(MRUNQ)
 
             SNDPGMMSG  MSG('Set on 2 o''clock flag executing') +
                        TOMSGQ(MRUNQ)
 
             CHGJOB   SWS(00000000)
             CALL       PGM(RE2003)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
