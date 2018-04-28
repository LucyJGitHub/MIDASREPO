/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Retail history for adjustment')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC3662A - RETAIL HISTORY FOR ADJUSTMENT                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/* */
/* NO SECURITY COPY OR JOURNALING NEEDED FOR RESTART . ONLY  */
/* THE FIELDS ADTY AND VDTC MIGTH BE UPDATED ON B RECORD OF REHISPD */
/* */
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/* */
             SNDPGMMSG  MSG('REC3662A - Retail History Adjustment    +
                          ') TOMSGQ(MRUNQ)
/* */
             OVRDBF     FILE(REHISPD) SEQONLY(*YES 100)
/* */
             CALL       PGM(RE3662A)
/* */
             DLTOVR *ALL
/* */
/* No  File control out of balance exist */
/* */
/* */
/* Database error or system error        */
/* */
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
               ENDDO
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDCL:       ENDPGM
