/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE LTRIX FILE SIZE CHANGE')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*             LEC05 - CUSTOMER LENDING FILE SIZE CHANGE            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR322731           Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      00                 Date 00/00/00             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       AR322731 - LEC0212A and APISERVER locks LTRIX file. Apply   */
/*                  fix 252833A. (Child:AR322732)                    */
/*       252833A  - Prevent LTRIX RRN 1 from being locked.           */
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&FLSZ) TYPE(*DEC) LEN(5)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&INCR) TYPE(*CHAR) LEN(1)
/**/
/**********  CALL       PGM(LE0016)   PARM(&FLSZ &INCR) */                               /*252833A*/
/**********  RTVJOBA    SWS(&SWS) */                                                     /*252833A*/
/**/
/**********  IF         COND(%SUBSTRING(&SWS 8 1) *NE '1') THEN(DO) */                   /*252833A*/
/**/
/**********     IF         COND(&INCR *EQ 'Y') THEN(DO)                                  /*252833A*/
/**/
/**********        INZPFM     FILE(LTRIX)  TOTRCDS(&FLSZ) */                             /*252833A*/
/**********        MONMSG     MSGID(CPF0000) */                                          /*252833A*/
/**********        SNDPGMMSG  MSG('LTRIX File size increase +          +
                                     executed') TOMSGQ(MOPERQ) */                        /*252833A*/
/**/
/**********     ENDDO */                                                                 /*252833A*/
/**/
/**********     ENDDO */                                                                 /*252833A*/
/**/
/**********  ELSE       CMD(SNDMSG  MSG('Job terminated - database in error') +
                            TOMSGQ(MOPERQ)) */                                           /*252833A*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
