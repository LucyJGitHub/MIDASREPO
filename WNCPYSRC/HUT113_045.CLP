/*    *****************************************************************                     HUT113*/
/*    *                                                               *                     HUT113*/
/*    *  Midas - /COPY Member (RPG)                                   *                     HUT113*/
/*    *                                                               *                     HUT113*/
/*    *  SCC0700                                                      *                     HUT113*/
/*    *                                                               *                     HUT113*/
/*    *  Last Amend No. HUT113    *CREATE  Date 01Apr20               *                     HUT113*/
/*    *                                                               *                     HUT113*/
/*    *---------------------------------------------------------------*                     HUT113*/
/*    *                                                               *                     HUT113*/
/*    *  HUT113 - Upgrade HUT026 to FBM 2.1 SP 22                     *                     HUT113*/
/*    *         - Full Private Banking Functionality in Midas         *                     HUT113*/
/*    *         - Allow Portfolio Definitions Input in Midas          *                     HUT113*/
/*    *                                                               *                     HUT113*/
/*    *****************************************************************                     HUT113*/
                CHGVAR     VAR(&SARD) VALUE('HUT113')                                     /*HUT113*/
                CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                     /*HUT113*/
                CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                      /*HUT113*/
                IF         COND(&RTN *NE '       ') THEN(DO)                              /*HUT113*/
/*    *****************************************************************                     HUT113*/
/*    * End of /COPY HUT113_045                                       *                     HUT113*/
/*    *****************************************************************                     HUT113*/
