/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas ABS ER INTERFACE WITH PUMA-MINERV')            */
/********************************************************************/
/*                                                                  */
/*     Midas - Compare routine                                      */
/*                                                                  */
/*     ERC4900 - CL controller                                      */
/*                                                                  */
/*     (C) Copyright Midas-Kapiti International Ltd. 2001           */
/*                                                                  */
/*     Last Amend No. MD058100           Date 20May21               */
/*                                                                  */
/********************************************************************/
/*     MD058100 - Rollup of additional BoI onsite fixes at FbMidas  */
/*     MMI100   - *Create                                           */
/********************************************************************/
/*                                                                  */
/* Parameters: - the two files to compare                           */
/*             - key to sort the files upon                         */
/*               ( Only one key field is allowed at the moment )    */
/*                                                                  */
/********************************************************************/
/*                                                                  */
             PGM        PARM(&WFIL1 &WFIL2 &WKEY &WFIL3 &WLIB3 +
                          &WLIB1 &WLIB2)
/*                                                                  */
/* Variables                                                        */
             DCL        VAR(&WFIL1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFIL2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFIL3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKEY)  TYPE(*CHAR) LEN(10)
/*                                                                  */
/* Remove temporary files                                           */
             DLTF       FILE(QTEMP/ER4900PD*)
             MONMSG     MSGID(CPF0000)
/*                                                                  */
/* First copy/sort                                                  */
             OPNQRYF    FILE((&WLIB1/&WFIL1)) KEYFLD((&WKEY))
             CPYFRMQRYF FROMOPNID(&WFIL1) TOFILE(QTEMP/ER4900PDT1) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CLOF       OPNID(&WFIL1)
/*                                                                  */
/* Second copy/sort                                                 */
             OPNQRYF    FILE((&WLIB2/&WFIL2)) KEYFLD((&WKEY))
             CPYFRMQRYF FROMOPNID(&WFIL2) TOFILE(QTEMP/ER4900PDT2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CLOF       OPNID(&WFIL2)
/*                                                                  */
/* Extract DDS from files                                           */
             DSPFFD     FILE(&WLIB1/&WFIL1) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/ER4900PDT3)
             DSPFFD     FILE(&WLIB2/&WFIL2) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/ER4900PDT4)
/*                                                                  */
/* Copy work file layout in QTEMP                                   */
             CRTDUPOBJ  OBJ(ER4900PD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/*                                                                  */
/* Override the output file                                         */
             OVRDBF     FILE(ER4900PD) TOFILE(QTEMP/ER4900PD)
/*                                                                  */
/* Override the DSPFFD files                                        */
             OVRDBF     FILE(ER4900PDT3) TOFILE(QTEMP/ER4900PDT3)
             OVRDBF     FILE(ER4900PDT4) TOFILE(QTEMP/ER4900PDT4)
/*                                                                  */
/* Run compare program                                              */
             CALL       PGM(ER4900) PARM(&WKEY)
/*                                                                  */
/* Remove overrides                                                */
             DLTOVR     FILE(ER4900PD)
             DLTOVR     FILE(ER4900PDT3)
             DLTOVR     FILE(ER4900PDT4)
/*                                                                  */
/* Copy work file into target library                               */
             CPYF       FROMFILE(QTEMP/ER4900PD) +
                          TOFILE(&WLIB3/&WFIL3) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
/*                                                                  */
/* If the output file is already there, remove it                   */
             MONMSG     MSGID(CPF0000) EXEC(DO)
/*                                                                  */
             CRTDUPOBJ  OBJ(ER4900PD) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(&WLIB3) NEWOBJ(&WFIL3) DATA(*NO)
/*                                                                  */
             MONMSG     MSGID(CPD2104 CPF2130) EXEC(DO)
             CLRPFM     FILE(&WLIB3/&WFIL3)
             ENDDO
/*                                                                  */
             ENDDO
/*                                                                  */
/* End of program                                                   */
 END:        ENDPGM
