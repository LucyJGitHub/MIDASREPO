/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas SE Pos Sett Unauthorised/Auth Today Rpt')       */
/********************************************************************/
/*                                                                  */
/*       Midas - Securities Trading Module                          */
/*                                                                  */
/********SECHA24*-*Position*Settlement*Unauthorised/Authorised*******/                   /*HUT105*/
/*       XXC10524A - Position Settlement Unauthorised/Authorised    */                   /*HUT105*/
/*                   Today Report (I/C)                             */
/*                                                                  */
/********(c)*Misys*International*Banking*Systems*Ltd.*2008***********/                   /*HUT105*/
/*       (c) Finastra International Systems Ltd. 2020               */                   /*HUT105*/
/*                                                                  */
/*       Last Amend No. HUT105            Date 07Apr20              */
/*       Prev Amend No. HUT011  *CREATE   Date 12May08              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       HUT105 - Bulk Position Settlement Authorisation            */
/*                (Upgrade HUT011/015 to FM2.1 SP22)                */
/*       HUT011 - Bulk Position Settlement Authorisation            */
/*                                                                  */
/********************************************************************/

             PGM        PARM(&SEQN &SESN &DUDT &EVTP)

             DCL        VAR(&SEQN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SESN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DUDT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EVTP) TYPE(*CHAR) LEN(2)

             STRCMTCTL  LCKLVL(*ALL)
             MONMSG     MSGID(CPF0000)

/*           CALL       PGM(FCCH201) PARM('SECH024' &SEQN 'SEH024' +
                          'B' &SESN &DUDT &EVTP)                               */        /*HUT105*/
             CALL       PGM(XXC0201) PARM('XXC105024' &SEQN 'XX105024' 'B' &SESN +
                          &DUDT &EVTP) /*HUT105*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)

             ENDPGM
