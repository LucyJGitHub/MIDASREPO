/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GP Extract ML Exposure')                        */
/*********************************************************************/
/*                                                                   */
/*  Midas - Global Processing Module                                 */
/*                                                                   */
/*  GPCEXTMLEX - Extract ML Exposure                                 */
/*                                                                   */
/*  (c) Finastra International Limited 2020                          */
/*                                                                   */
/*  Last Amend No. EML109  *CREATE    Date 10Feb20                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  EML109 - Upgrade of NAD1 to FB2.1 SP21                           */
/*           NADC01 - ML Extracts for Mizuho                         */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRTCD)   TYPE(*CHAR) LEN(7)   VALUE(' ')
             DCL        VAR(&PERMS)   TYPE(*CHAR) LEN(50)  VALUE(' ')
             DCL        VAR(&PFULLCK) TYPE(*CHAR) LEN(7)   VALUE('Y')
             DCL        VAR(&PZONE)   TYPE(*CHAR) LEN(10)  VALUE(' ')
             DCL        VAR(&PSHTC)   TYPE(*CHAR) LEN(4)   VALUE(' ')
             DCL        VAR(&PRDNB)   TYPE(*DEC)  LEN(5 0) VALUE(0)
             DCL        VAR(&PDNWD)   TYPE(*DEC)  LEN(5 0) VALUE(0)
             DCL        VAR(&PBCCY)   TYPE(*CHAR) LEN(3)   VALUE(' ')
             DCL        VAR(&PNJOB)   TYPE(*DEC)  LEN(1 0) VALUE(0)

             CALL       PGM(GOGETZONE) PARM(&PRTCD &PERMS &PFULLCK +
                          &PZONE &PSHTC &PRDNB &PDNWD &PBCCY &PNJOB)

             CLRPFM     FILE(TXMLTRNEXP)
             CLRPFM     FILE(TXUCAPTRAN)
             CALL       PGM(GPEXTMLDT)

             CLRPFM     FILE(GPMLEXPD)
             CALL       PGM(GPEXTMLEX) PARM(&PZONE)

             CALL       PGM(GPRPTMLEX) PARM(&PZONE)

             CALL       PGM(GPRPTMLUT) PARM(&PZONE)


             ENDPGM
