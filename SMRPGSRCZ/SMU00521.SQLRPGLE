     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update SFC0521 Seq using Components File')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00521 - Update SFC0521 Seq using Components File          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD020693 *CREATE   Date 18Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020693 - CBC022001 failed due to MUSER file locking        *
      *                                                               *
      *****************************************************************
      *                                                               *
     D SFCSEQ          S              5A   INZ
 
      ** Work Variables for SNDPGMMSG ( for logging )
 
     D MsgDta          S             50A   INZ
     D MsgKey          S              4A   INZ
 
     D ErrDS           DS                  QUALIFIED
     D  BytesProv                    10I 0 INZ( %SIZE( ErrDS ) )
     D  BytesAvail                   10I 0
     D  ExceptionID                   7A
     D                                1A
     D  ExceptionDta                256A
 
      ** Prototype for SNDPGMMSG
 
     D SendPgmMsg      PR                  EXTPGM('QMHSNDPM')
     D  MsgID                         7A   CONST
     D  MsgFile                      20A   CONST
     D  MsgDta                       80A   CONST
     D  MsgDtaLen                    10I 0 CONST
     D  MsgType                      10A   CONST
     D  MsgQ                         10A   CONST
     D  MsgQNbr                      10I 0 CONST
     D  MsgKey                        4A
     D  Error                              LIKE( ErrDS )
 
      ** Retrieve sequence of SFC0521 from Components File
      ** If none retrieved, exit program
 
     C/EXEC SQL
     C+ select DHCSEQ into :SFCSEQ
     C+ from CBCMPNPD
     C+ where DHCOTT = 'SFC0521'
     C/END-EXEC
 
     C                   IF        SQLER2 = 0
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Update FCRREQPD with sequence from Components File
      ** Log result of action, return SQLCODE if error
      ** otherwise, number of records updated
 
     C/EXEC SQL
     C+ update FCRREQPD
     C+ set D5CSEQ = :SFCSEQ
     C+ where D5COTT = 'SFC0521'
     C/END-EXEC
 
     C                   IF        SQLCODE < 0
     C                   EVAL      MsgDta = 'Error updating FCRREQPD: ' +
     C                                       %CHAR( SQLCODE )
 
 
     C                   ELSEIF    SQLER3 = 0
     C                   EVAL      MsgDta = 'NO FCRREQPD record to update'
     C                   ELSEIF    SQLER3 > 0
     C                   EVAL      MsgDta = %CHAR( SQLER3 ) + ' FCRREQPD +
     C                                       record(s) has been updated'
     C                   ENDIF
 
     C                   CALLP     SENDPGMMSG( 'CPF9898'
     C                                       : 'QCPFMSG   QSYS'
     C                                       : %TRIM( MsgDta )
     C                                       : %LEN( %TRIM( MsgDta ) )
     C                                       : '*INFO'
     C                                       : '*PGMBDY'
     C                                       : 1
     C                                       : MsgKey
     C                                       : ErrDS                    )
 
      ** Update FCPREQPD with sequence from Components File
      ** Log result of action, return SQLCODE if error
      ** otherwise, number of records updated
 
     C/EXEC SQL
     C+ update FCPREQPD
     C+ set D9CSEQ = :SFCSEQ
     C+ where D9COTT = 'SFC0521'
     C/END-EXEC
 
     C                   IF        SQLCODE < 0
     C                   EVAL      MsgDta = 'Error updating FCPREQPD: ' +
     C                                       %CHAR( SQLCODE )
     C                   ELSEIF    SQLER3 = 0
     C                   EVAL      MsgDta = 'NO FCPREQPD record to update'
     C                   ELSEIF    SQLER3 > 0
     C                   EVAL      MsgDta = %CHAR( SQLER3 ) + ' FCPREQPD +
     C                                       record(s) has been updated'
     C                   ENDIF
 
     C                   CALLP     SENDPGMMSG( 'CPF9898'
     C                                       : 'QCPFMSG   QSYS'
     C                                       : %TRIM( MsgDta )
     C                                       : %LEN( %TRIM( MsgDta ) )
     C                                       : '*INFO'
     C                                       : '*PGMBDY'
     C                                       : 1
     C                                       : MsgKey
     C                                       : ErrDS                    )
 
      ** Update CBCOBRPD with sequence from Components File
      ** Log result of action, return SQLCODE if error
      ** otherwise, number of records updated
 
     C/EXEC SQL
     C+ update CBCOBRPD
     C+ set CRCSEQ = :SFCSEQ
     C+ where CRCOTT = 'SFC0521'
     C/END-EXEC
 
     C                   IF        SQLCODE < 0
     C                   EVAL      MsgDta = 'Error updating CBCOBRPD: ' +
     C                                       %CHAR( SQLCODE )
     C                   ELSEIF    SQLER3 = 0
     C                   EVAL      MsgDta = 'NO CBCOBRPD record to update'
     C                   ELSEIF    SQLER3 > 0
     C                   EVAL      MsgDta = %CHAR( SQLER3 ) + ' CBCOBRPD +
     C                                       record(s) has been updated'
     C                   ENDIF
 
     C                   CALLP     SENDPGMMSG( 'CPF9898'
     C                                       : 'QCPFMSG   QSYS'
     C                                       : %TRIM( MsgDta )
     C                                       : %LEN( %TRIM( MsgDta ) )
     C                                       : '*INFO'
     C                                       : '*PGMBDY'
     C                                       : 1
     C                                       : MsgKey
     C                                       : ErrDS                    )
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
