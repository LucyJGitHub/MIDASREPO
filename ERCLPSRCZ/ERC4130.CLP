/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ABS ER INTERFACE WITH PUMA-MINERV')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy                   */
/*                                                                   */
/*       ERC4130 - ER INTERFACE WITH PUMA-MINERVA                    */
/*                MINERVA Interface with system in OUTSOURCING       */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1999          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 04Jan21              */
/*       Prev Amend No. MMI100             Date 05Nov02              */
/*                      MMI093             Date 04Mar02              */
/*                      MMI033                  06MAY99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       MMI100 - Renamed from IRC4002 to ERC4130                    */
/*       MMI093 - Rewritten                                          */
/*       MMI033 - Bank Of Italy Monthly Reporting                    */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MONTH) TYPE(*CHAR) LEN(3)

/* Get the library prefix */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&ERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')

             CLRPFM     FILE(&ERDLIB/IRM21OPD)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(&ERDLIB/IRM21OPD) RCDLEN(80) +
                          SIZE(*NOMAX))

             CLRPFM     FILE(&ERDLIB/IRM25OPD)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(&ERDLIB/IRM25OPD) RCDLEN(80) +
                          SIZE(*NOMAX))

             CLRPFM     FILE(&ERDLIB/IRM71OPD)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(&ERDLIB/IRM71OPD) RCDLEN(80) +
                          SIZE(*NOMAX))

/* Only during December extraction, output Voci 4000 */

             CHKOBJ     OBJ(&ERDLIB/IRM40OPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&ERDLIB/IRM40OPD) RCDLEN(80) +
                          SIZE(*NOMAX))

             RTVDTAARA  DTAARA(RUNDAT (3 3)) RTNVAR(&MONTH )
             IF         COND(&MONTH = 'DEC') THEN(DO)
             CLRPFM     FILE(&ERDLIB/IRM40OPD)
/*********** CALL       PGM(IR4130) PARM(Y) */                        /*MMI100*/
             CALL       PGM(ER4130) PARM(Y)                           /*MMI100*/
             ENDDO
/*********** ELSE       CMD(CALL PGM(IR4130)*PARM(N)) */              /*MMI100*/
             ELSE       CMD(CALL PGM(ER4130) PARM(N))                 /*MMI100*/

/*********** CALL       PGM(IR4140) */                                /*MMI100*/
             CALL       PGM(ER4140)                                   /*MMI100*/

             ENDPGM
