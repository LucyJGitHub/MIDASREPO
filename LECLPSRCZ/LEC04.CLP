/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Input cycle termination')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC04 -  INPUT CYCLE TERMINATION - CUSTOMER LENDING        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01194             DATE 06MAR90             */
/*       PREV AMEND NO. S01179             DATE 14SEP88             */
/*                                                                  */
/********************************************************************/
/*     S01194 - NEW STANDING DATA                                   */
/*     S01179 - AS400 INCORPORATION                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL VAR(&LESTAT) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,LEC04001                                            */
/*           DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/**/
             SNDPGMMSG  MSG('INPUT CYCLE TERMINATION - CUSTOMER +
                         LENDING') TOMSGQ(MRUNQ)
             CALL       PGM(LEC0401)
/**/
             IF         COND(%SWITCH(XXXX0000)) THEN(DO)
                CALL       PGM(LEC0402)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXX0000)) THEN(DO)
                ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
                RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
/**/
                CHGVAR     VAR(%SUBSTRING(&LESTAT 15 3)) VALUE(NNN)
             CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)
                DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
             ENDDO
/*/COPY WNCPYSRC,LEC04002                                            */
/**/                                                                /*S01194*/
/* MUST FREE ALL FILES SO THAT SDC1711 CAN ENDJRN                */ /*S01194*/
/**/                                                                /*S01194*/
             RCLRSC     LVL(*CALLER)                                /*S01194*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
