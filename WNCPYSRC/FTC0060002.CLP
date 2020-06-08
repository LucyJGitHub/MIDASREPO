/*********************************************************************/               /*HUT101*/
/*                                                                   */               /*HUT101*/
/*       MIDAS - /COPY Member FTC0060                                */               /*HUT101*/
/*                                                                   */               /*HUT101*/
/*       FTC0060002 - Payment Authorisation for Funds Transfer       */               /*HUT101*/
/*                                                                   */               /*HUT101*/
/*       Last Amend No. HUT101  *CREATE    DATE 27Mar20              */               /*HUT101*/
/*                                                                   */               /*HUT101*/
/*********************************************************************/               /*HUT101*/
/*                                                                   */               /*HUT101*/
/*       HUT101 - Payment Authorisation for Funds Transfer           */               /*HUT101*/
/*                                                                   */               /*HUT101*/
/*********************************************************************/               /*HUT101*/
                                                                                      /*HUT101*/
             CHGVAR     VAR(&SARD) VALUE('HUT101')                                    /*HUT101*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SARD &FMT)                  /*HUT101*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                          /*HUT101*/
                CPYF       FROMFILE(V_ALLIMIT) TOFILE(XXALLIMT) MBROPT(*REPLACE) +
                             CRTFILE(*YES) FMTOPT(*NOCHK)                             /*HUT101*/
             ENDDO                                                                    /*HUT101*/
                                                                                      /*HUT101*/
/**********************************************************************/              /*HUT101*/
/* End of /COPY FTC0060002                                           **/              /*HUT101*/
/**********************************************************************/              /*HUT101*/
