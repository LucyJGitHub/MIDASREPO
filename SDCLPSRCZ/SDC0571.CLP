/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Check module positions')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                            */
/*                                                                   */
/*       SDC0571  - Check module positions                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CRM001             Date 08Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       CRM001 - Interest Risk Management changes:                  */
/*                New program to check the module flags on           */
/*                SDMMODPD.                                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POSN &RTCD)
 
 
/***COPY*SDCPYSRC,SDC0571INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC0571INT                                          */                   /*CPK024*/
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)
             DCL        VAR(&POSN) TYPE(*DEC) LEN(3)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Initialise the return code to 'N' */
 
             CHGVAR     VAR(&RTCD) VALUE('N')
 
/* Move the entity module position into a numeric field */
 
/***COPY*SDCPYSRC,SDC0571MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC0571MPS                                          */                   /*CPK024*/
 
             CALL       PGM(AOMMODR0) PARM('*DBERR ' '*FIRST ' +
                          &MMOD)
 
             IF         COND(%SUBSTRING(&MMOD &POSN 1) *EQ 'Y') +
                          THEN(DO)
 
                CHGVAR     VAR(&RTCD) VALUE('Y')
             ENDDO
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/***COPY*SDCPYSRC,SDC0571END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC0571END                                          */                   /*CPK024*/
 
             ENDPGM
